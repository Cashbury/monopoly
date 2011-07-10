# == Schema Information
# Schema version: 20110615133925
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  password_salt          :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  remember_token         :string(255)
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  admin                  :boolean(1)
#  authentication_token   :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  last_name              :string(255)
#  telephone_number       :string(255)
#  username               :string(255)
#  mailing_address_id     :integer(4)
#  billing_address_id     :integer(4)
#  is_fb_account          :boolean(1)
#  note                   :text
#  home_town              :string(255)
#  language_of_preference :string(255)
#  default_currency       :string(255)
#  timezone               :string(255)
#  dob                    :date
#  is_terms_agreed        :boolean(1)
#  legal_id               :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable

  devise :database_authenticatable, :registerable,:token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:first_name,:last_name,
                  :authentication_token, :brands_attributes, :username, :telephone_number, :role_id
                  
  attr_accessor :role_id
  has_many :templates
  has_many :brands
  has_many :legal_ids, :as=>:associatable
  has_many :followers
  has_many :businesses, :through=>:followers
  has_many :invitations, :foreign_key=>"from_user_id"

  has_many :employees #same user with different positions
  has_many :roles, :through=>:employees
  has_many :logs
  has_many :followers, :as=>:followed
  has_many :business_customers
  has_many :businesses, :through=>:business_customers
  has_many :login_methods_users
  has_many :login_methods, :through=>"login_methods_users"
  has_one  :qr_code, :as=>:associatable
  has_one :account_holder, :as=>:model  
  has_and_belongs_to_many :rewards
  has_and_belongs_to_many :enjoyed_rewards, :class_name=>"Reward" , :join_table => "users_enjoyed_rewards"
  has_and_belongs_to_many :places
  #has_and_belongs_to_many :roles
  #has_and_belongs_to_many :login_methods
  belongs_to :mailing_address, :class_name=>"Address" ,:foreign_key=>"mailing_address_id"
  belongs_to :billing_address, :class_name=>"Address" ,:foreign_key=>"billing_address_id"


  #nested attributes
  accepts_nested_attributes_for :brands,
                                :allow_destroy => true # :reject_if => proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :mailing_address,:reject_if =>:all_blank
  accepts_nested_attributes_for :billing_address,:reject_if =>:all_blank
  before_save :set_default_role , :on =>:create


  def set_default_role
    current_roles = roles
    mobi =  Role.where(:name=>Role::AS[:mobi]).limit(1).first
    principal_user =  Role.where(:name=>Role::AS[:principal]).limit(1).first
    unless brands.blank?
      roles << principal_user unless current_roles.include? principal_user
    else
      roles << mobi unless current_roles.include? mobi
    end
  end

  #convinience method ====================
  def admin?
    role?(Role::AS[:admin])
  end

  def super_admin?
    role?(Role::AS[:super_admin])
  end

  #for business signup
  def with_brand
    self.brands.build if self.brands.blank?
    self
  end


  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end


	def has_account_with_campaign?(acch,campaign_id)
		!acch.nil? && !acch.accounts.where(:campaign_id=>campaign_id).empty?
	end

	def auto_enroll_at(places)
	  begin
      ids=places.collect{|p| p.business_id}
      targeted_campaigns_ids=[]
      businesses=Business.where(:id=>ids)
      accholder=self.account_holder
      businesses.each do |business|
        business.programs.each do |program|
          program.campaigns.each do |campaign|
            if !campaign.has_target? || self.is_engaged_with_campaign?(campaign) || (campaign.has_target? and self.is_targeted_from?(campaign))
              targeted_campaigns_ids << campaign.id
              unless self.has_account_with_campaign?(accholder,campaign.id)
                accholder=AccountHolder.create!(:model_id=>self.id,:model_type=>self.class.to_s) if accholder.nil?
                Account.create!(:campaign_id=>campaign.id,:amount=>campaign.initial_amount,:measurement_type=>campaign.measurement_type,:account_holder=>accholder)
              end
            end
          end
        end
      end
    rescue Exception=>e
      puts "Exception: #{e.message}"
      logger.error "Exception #{e.class}: #{e.message}"
    end
    targeted_campaigns_ids
	end

	def account_holder
	  AccountHolder.where(:model_id=>self.id,:model_type=>self.class.to_s).first
	end

	def snapped_qrcode(qr_code,engagement,place_id,lat,lng)
    campaign=engagement.campaign

    user_account=campaign.user_account(self)
    business_account=campaign.business_account

    date=Date.today.to_s
    Account.transaction do
      qr_code.scan
      #check if user has engaged with biz before else create record for it
      if self.business_customers.where(:business_id=>campaign.program.business).empty?
        self.business_customers.create(:business_id=>campaign.program.business)
      end
      if user_account.nil?
        accholder=AccountHolder.find_or_create_by_model_id_and_model_type(:model_id=>self.id,:model_type=>self.class.to_s)
        account=Account.create!(:campaign_id=>campaign.id,:amount=>campaign.initial_amount,:measurement_type=>campaign.measurement_type)
        accholder.accounts << account
        accholder.save!
        user_account=account
      end

      #debit business account and credit user account
      action=Action.where(:name=>Action::CURRENT_ACTIONS[:engagement]).first
      transaction_type=action.transaction_type
      after_fees_amount=transaction_type.fee_amount.nil? ? engagement.amount : engagement.amount-transaction_type.fee_amount
      after_fees_amount=transaction_type.fee_percentage.nil? ? after_fees_amount : (after_fees_amount-(after_fees_amount * transaction_type.fee_percentage/100))

      business_account_before_balance=business_account.amount
      business_account.decrement!(:amount,engagement.amount)

      user_account_before_balance=user_account.amount
      user_account.increment!(:amount,after_fees_amount)

      #save the transaction record
      transaction=Transaction.create!(:from_account=>business_account.id,
                                      :to_account=>user_account.id,
                                      :before_fees_amount=>engagement.amount,
                                      :payment_gateway=>user_account.payment_gateway,
                                      :is_money=>false,
                                      :from_account_balance_before=>business_account_before_balance,
                                      :from_account_balance_after=>business_account.amount,
                                      :to_account_balance_before=>user_account_before_balance,
                                      :to_account_balance_after=>user_account.amount,
                                      :currency=>nil,
                                      :note=>"User made an engagement using QR Code",
                                      :transaction_type_id=>action.transaction_type_id,
                                      :after_fees_amount=>after_fees_amount,
                                      :transaction_fees=>transaction_type.fee_amount)

      #save this engagement action to logs
      log_group=LogGroup.create!(:created_on=>date)
      if place_id.blank?
        unless lat.blank? || lng.blank?
          place_id=Place.closest(:origin=>[lat.to_f,lng.to_f]).first.id
        end
      end
      Log.create!(:user_id =>self.id,
                  :action_id      =>action.id,
                  :log_group_id   =>log_group.id,
                  :engagement_id  =>engagement.id,
                  :qr_code_id     =>qr_code.id,
                  :campaign_id    =>campaign.id,
                  :business_id    =>campaign.program.business.id,
                  :transaction_id =>transaction.id,
                  :place_id       =>place_id,
                  :gained_amount  =>after_fees_amount,
                  :amount_type    =>user_account.measurement_type,
                  :frequency      =>1,
                  :lat            =>lat,
                  :lng            =>lng,
                  :created_on     =>date)
      [user_account,campaign,campaign.program,after_fees_amount]
    end
	end

	def ensure_authentication_token!
    reset_authentication_token! if authentication_token.blank?
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def engaged_with_business?(business)
    !self.business_customers.where(:business_id=>business.id).empty?
  end

  def is_targeted_from?(campaign)
    campaign.targets.each do |target|
      return target.name=="new_comers" ? !self.engaged_with_business?(campaign.program.business) : self.engaged_with_business?(campaign.program.business)
    end
  end
  
  def is_engaged_with_campaign?(campaign)
    !self.logs.where(:campaign_id=>campaign.id).limit(1).empty?
  end
end
