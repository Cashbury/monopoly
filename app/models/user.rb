# == Schema Information
# Schema version: 20101218032208
#
# Table name: users
#
#  id                   :integer         primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :timestamp
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :timestamp
#  last_sign_in_at      :timestamp
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :timestamp
#  updated_at           :timestamp
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,:token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:first_name,:last_name,:authentication_token
   
  has_many :templates
  has_many :legal_ids, :as=>:associatable
  has_many :followers
  has_many :businesses, :through=>:followers
  has_many :invitations, :foreign_key=>"from_user_id"
  
  has_many :employees #same user with different positions
  has_many :logs
  has_many :followers, :as=>:followed
  
  has_one :qr_code, :as=>:associatable
  has_one :account_holder, :as=>:model
  has_one :mailing_address, :class_name=>"Address" ,:foreign_key=>"mailing_address_id"
  has_one :billing_address, :class_name=>"Address" ,:foreign_key=>"billing_address_id"
  has_and_belongs_to_many :rewards
  has_and_belongs_to_many :enjoyed_rewards, :class_name=>"Reward" , :join_table => "users_enjoyed_rewards"

	def has_account_with_campaign?(campaign_id)
	  acch=self.account_holder
		!acch.nil? && !acch.accounts.where(:campaign_id=>campaign_id).empty?
	end
	
	def auto_enroll_at(places)
	  begin
      ids=places.collect{|p| p.business_id}
      businesses=Business.where(:id=>ids)
      accholder=self.account_holder
      businesses.each do |business|
        business.programs.each do |program|
          program.campaigns.each do |campaign|
            unless self.has_account_with_campaign?(campaign.id)
              accholder=AccountHolder.create!(:model_id=>self.id,:model_type=>self.class.to_s) unless accholder
              accholder.accounts << Account.create!(:campaign_id=>campaign.id,:amount=>campaign.initial_amount,:measurement_type=>campaign.measurement_type)
              accholder.save!
            end
          end
        end
      end
    rescue Exception=>e
      puts "Exception: #{e.message}"
      logger.error "Exception #{e.class}: #{e.message}"
    end
	end
	
	def account_holder
	  AccountHolder.where(:model_id=>self.id,:model_type=>self.class.to_s).first
	end
	
	def snapped_qrcode(qr_code,place_id,lat,lng)
    engagement=qr_code.engagement
    campaign=engagement.campaign
 
    user_account=campaign.user_account(self)
    business_account=campaign.business_account
    
    date=Date.today.to_s
    Account.transaction do
      qr_code.scan
      if user_account.nil?
        accholder=AccountHolder.create!(:model_id=>self.id,:model_type=>self.class.to_s) unless self.account_holder
        account=Account.create!(:campaign_id=>campaign.id,:amount=>campaign.initial_amount,:measurement_type=>campaign.measurement_type)
        accholder.accounts << account
        accholder.save!
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
      Log.create!(:user_id =>self.id,
                  :action_id      =>action.id,
                  :log_group_id   =>log_group.id,
                  :engagement_id  =>engagement.id,
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
end
