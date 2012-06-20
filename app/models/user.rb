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


  make_flagger :flag_once => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:first_name,:last_name,
                  :authentication_token, :brands_attributes, :username, :telephone_number, :role_id, :home_town, :mailing_address_id, :billing_address_id , :is_fb_status_enabled

  attr_accessor :role_id
  has_many :templates
  has_many :brands
  has_many :legal_ids, :as=>:associatable
  has_many :followers
  has_many :businesses, :through=>:followers
  has_many :invitations, :foreign_key=>"from_user_id"
  has_many :receipts, :dependent=>:destroy
  has_many :employees #same user with different positions
  has_many :roles, :through=>:employees
  has_many :logs
  has_many :places
  has_many :followers, :as=>:followed
  has_many :business_customers
  has_many :businesses, :through=>:business_customers
  has_many :login_methods_users
  has_many :login_methods, :through=>"login_methods_users"

  has_one  :qr_code, :as=>:associatable, :conditions => {:status=>1}
  has_one :business, :through => :employees

  has_one :account_holder, :as=>:model
  has_many :accounts, :through => :account_holder

  has_and_belongs_to_many :rewards
  has_and_belongs_to_many :enjoyed_rewards, :class_name=>"Reward" , :join_table => "users_enjoyed_rewards"
  has_and_belongs_to_many :pending_receipts, :class_name=>"Receipt" , :join_table => "users_pending_receipts"
  has_and_belongs_to_many :places
  has_and_belongs_to_many :programs, :join_table => "users_programs"
  
  belongs_to :mailing_address, :class_name=>"Address" ,:foreign_key=>"mailing_address_id"
  belongs_to :billing_address, :class_name=>"Address" ,:foreign_key=>"billing_address_id"
  belongs_to :country, :foreign_key=>"home_town"

  #nested attributes
  accepts_nested_attributes_for :brands,
                                :allow_destroy => true # :reject_if => proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :mailing_address,:reject_if =>:all_blank
  accepts_nested_attributes_for :billing_address,:reject_if =>:all_blank
  after_create :set_default_role, :add_cash_incentives
  after_create :initiate_user_code
  before_save :add_country_code_to_phone

  scope :with_account_at_large , select("users.*, (SELECT accounts.amount from users left outer join account_holders on users.id=account_holders.model_id left outer join accounts on accounts.account_holder_id=account_holders.id where accounts.business_id=0) AS amount")
  scope :with_code, joins("LEFT OUTER JOIN qr_codes ON qr_codes.associatable_id=users.id and qr_codes.associatable_type='User'").select("qr_codes.hash_code").group("users.id")



  validates_format_of :telephone_number, :with => /^[0-9]+$/, :message=>"Phone should contain numbers only",:allow_blank=>true
  cattr_reader :per_page
  @@per_page = 20

  def self.terms(terms)
    return scoped if terms.blank?
    composed_scope = scoped
    terms.split(/[^A-Za-z0-9_\-]+/).map { |term| "%#{term}%" }.each do |term|
      composed_scope = composed_scope.with_code.where('qr_codes.hash_code LIKE :term OR email LIKE :term OR first_name LIKE :term OR last_name LIKE :term OR telephone_number LIKE :term ', { :term => term })
    end
    composed_scope
  end
  
  def initiate_user_code
    issue_qrcode(0, 0, QrCode::SINGLE_USE)
  end
  
  def set_default_role
    current_roles = roles
    consumer ||=  Role.where(:name=>Role::AS[:consumer]).limit(1).first
    principal_user ||=  Role.where(:name=>Role::AS[:principal]).limit(1).first

    unless brands.blank?
      roles << principal_user unless current_roles.include? principal_user
    else
      roles << consumer unless current_roles.include? consumer
    end
  end

  def add_cash_incentives
    if self.consumer?
      campaigns = Campaign.where("ctype = ? and end_date > ?", 
                                 Campaign::CTYPE[:cash_incentive],
                                 DateTime.now)
      campaigns.each do |campaign|
        Delayed::Job.enqueue(CashIncentive.new(self.id, campaign.id))
      end
    end
  end

  #convinience method ====================
  def admin?
    role?(Role::AS[:admin])
  end
  
  def cashier?
    role?(Role::AS[:cashier])
  end

  def super_admin?
    role?(Role::AS[:super_admin])
  end

  def consumer?
    role?(Role::AS[:consumer])
  end

  #for business signup
  def with_brand
    self.brands.build if self.brands.blank?
    self
  end


  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def activate
    self.active=true
    save!
  end

  def suspend
    self.active=false
    save!
  end

	def has_account_with_campaign?(acch,campaign_id)
		!acch.nil? && !acch.accounts.where(:campaign_id=>campaign_id).empty?
	end
  
  def enroll(program)
    User.transaction do
      self.programs << program
      if program.program_type == ProgramType['Money']
        self.create_account_holder if account_holder.blank?
        Account.create :business_id => program.business_id,
          :program_id => program.id,
          :is_money => true,
          :account_holder_id => self.account_holder.id
        Account.create :business_id => program.business_id,
          :program_id => program.id,
          :is_cashbury => true,
          :account_holder_id => self.account_holder.id
      end
    end
  end

  def cash_incentive(business, amount, campaign_id)
    cash_account = self.cashbury_account_for(business)
    program = Program.find_or_create_by_business_id_and_program_type_id(:business_id=>business.id,:program_type_id=>ProgramType['Money'])
    marketing_program = Program.find_or_create_by_business_id_and_program_type_id(:business_id=>business.id,:program_type_id=>ProgramType['Marketing'])
    if !cash_account
      self.enroll(program)
      cash_account = self.cashbury_account_for(business)
    end
    account_holder_id = self.account_holder.id
    campaign_account = Account.where(:business_id => business.id, 
                                     :campaign_id => campaign_id,
                                     :account_holder_id => account_holder_id).first
    if !campaign_account
      Account.create(:business_id => business.id,
      :program_id => marketing_program.id,
      :account_holder_id => account_holder_id,
      :campaign_id => campaign_id)
      # Determining transactions with this business
      account_ids = Account.where(:account_holder_id => account_holder_id).select(:id).map(&:id)
      transactions_count = business.transactions.where('from_account IN (?) OR to_account IN (?)',
                                                       account_ids, account_ids).count
      cash_account.load(amount, nil, campaign_id) if transactions_count == 0
    end
  end


  # This method is more of a sanity check
  # to ensure that self.programs actually contains
  # the requested program.
  def money_program_for(business)
    money_program = business.money_program
    self.programs.where(:id => money_program.id).first
  end

  def cash_account_for(business)
    ensure_account_holder!
    money_program = business.money_program
    Account.where(:business_id => business.id)
      .where(:program_id => money_program.id)
      .where(:is_money => true)
      .where(:account_holder_id => self.account_holder.id)
      .first
  end

  def cashbury_account_for(business)
    ensure_account_holder!
    money_program = business.money_program
    Account.where(:business_id => business.id)
      .where(:program_id => money_program.id)
      .where(:is_cashbury => true)
      .where(:account_holder_id => self.account_holder.id)
      .first
  end

  def cashbury_accounts
    ensure_account_holder!
    Account.where(:is_cashbury => true)
      .where(:account_holder_id => self.account_holder.id)
  end

  def cashout_at(business)
    raise "Can't cashout without money program (User: #{id})" unless money_program_for(business).present?
    cash_account_for(business).cashout
  end
	def auto_enroll_at(places)
	  begin
      ids=places.collect{|p| p.business_id}
      targeted_campaigns_ids=[]
      businesses=Business.where(:id=>ids)
      accholder=self.account_holder
      businesses.each do |business|
        business.programs.each do |program|
          if program.is_money? && !self.programs.include?(program)
            self.enroll(program)
          end
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

  def money_account_at_large
    unless (accholder=self.account_holder).nil?
      accholder.accounts.where("accounts.business_id= NULL").first
    end
  end
  
  def engaged_with(associatable, engagement_amount, qr_code, place_id, lat, lng, note, freq=1, log_group, issued_by)
    campaign=associatable.campaign
    user_account=campaign.user_account(self)
    business_account=campaign.business_account
    date=Date.today.to_s
    Account.transaction do
      qr_code.scan if qr_code.present?
      #check if user has engaged with biz before else create record for it
      if self.business_customers.where(:business_id=>campaign.program.business.id).empty?
        self.business_customers.create(:business_id=>campaign.program.business.id)
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
      after_fees_amount=transaction_type.fee_amount.nil? || transaction_type.fee_amount.zero? ? engagement_amount : engagement_amount-transaction_type.fee_amount
      after_fees_amount=transaction_type.fee_percentage.nil? || transaction_type.fee_percentage.zero? ? after_fees_amount : after_fees_amount-(after_fees_amount * transaction_type.fee_percentage/100)
      after_fees_amount = after_fees_amount * freq
     
      business_account_before_balance= business_account.amount
      business_account.decrement!(:amount,engagement_amount * freq)
      user_account_before_balance= user_account.amount
      user_account.increment!(:amount,after_fees_amount)
      user_account.increment!(:cumulative_amount,after_fees_amount)
      
      #save the transaction record
      transaction=Transaction.create!(:from_account => business_account.id,
                                      :to_account => user_account.id,
                                      :before_fees_amount => engagement_amount * freq,
                                      :payment_gateway => user_account.payment_gateway,
                                      :is_money => false,
                                      :from_account_balance_before => business_account_before_balance,
                                      :from_account_balance_after => business_account.amount,
                                      :to_account_balance_before => user_account_before_balance,
                                      :to_account_balance_after => user_account.amount,
                                      :currency => nil,
                                      :note => note,
                                      :transaction_type_id => action.transaction_type_id,
                                      :after_fees_amount => after_fees_amount,
                                      :transaction_fees => transaction_type.fee_amount)

      #save this engagement action to logs
      log_group=LogGroup.create!(:created_on=>date) if log_group.nil?
      business_id = campaign.program.business.id
      if place_id.blank?
        unless lat.blank? || lng.blank?
          place_id=Place.where(:business_id => business_id).closest(:origin=>[lat.to_f,lng.to_f]).first.id
        end
      end
      Log.create!(:user_id        =>self.id,
                  :action_id      =>action.id,
                  :log_group_id   =>log_group.id,
                  :engagement_id  =>associatable.id,
                  :qr_code_id     =>qr_code.try(:id),
                  :campaign_id    =>campaign.id,
                  :business_id    =>business_id,
                  :transaction_id =>transaction.id,
                  :place_id       =>place_id,
                  :gained_amount  =>after_fees_amount,
                  :amount_type    =>user_account.measurement_type,
                  :frequency      =>freq,
                  :lat            =>lat,
                  :lng            =>lng,
                  :created_on     =>date,
                  :issued_by      =>issued_by)
      {:log_group=>log_group,:user_account=>user_account,:campaign=>campaign, :program=>campaign.program, :after_fees_amount=> after_fees_amount, :transaction=> transaction, :place_id=> place_id, :frequency=>freq}
    end  
  end
  
	def snapped_qrcode(qr_code,associatable,place_id,lat,lng, issued_by)
	  if associatable.class.to_s=="Engagement"
      result=engaged_with(associatable,associatable.amount,qr_code,place_id,lat,lng,"User made an engagement using QR Code",1,nil,issued_by)          
    elsif associatable.class.to_s=="User"
      date=Date.today.to_s
      action=Action.where(:name=>Action::CURRENT_ACTIONS[:engagement]).first
      Account.transaction do
        qr_code.scan        
        log_group=LogGroup.create!(:created_on=>date)
        if place_id.blank?
          unless lat.blank? || lng.blank?
            place_id=Place.closest(:origin=>[lat.to_f,lng.to_f]).first.id
          end
        end
        Log.create!(:user_id        =>self.id,
                    :action_id      =>action.id,
                    :log_group_id   =>log_group.id,
                    :engagement_id  =>associatable.id,
                    :qr_code_id     =>qr_code.id,
                    :place_id       =>place_id,
                    :lat            =>lat,
                    :lng            =>lng,
                    :created_on     =>date,
                    :issued_by      =>issued_by)
          [user_account,campaign,campaign.program,after_fees_amount]
        end
      elsif associatable.class.to_s=="User"
        date=Date.today.to_s
        action=Action.where(:name=>Action::CURRENT_ACTIONS[:engagement]).first
        Account.transaction do
          qr_code.scan
          QrCode.create(:code_type => QrCode::SINGLE_USE,:status=>1,:associatable_id=>associatable.id,:associatable_type=>QrCode::USER_TYPE,:size=>qr_code.size)
          log_group=LogGroup.create!(:created_on=>date)
          if place_id.blank?
            unless lat.blank? || lng.blank?
              place_id=Place.closest(:origin=>[lat.to_f,lng.to_f]).first.id
            end
          end
          Log.create!(:user_id        =>self.id,
                      :action_id      =>action.id,
                      :log_group_id   =>log_group.id,
                      :engagement_id  =>associatable.id,
                      :qr_code_id     =>qr_code.id,
                      :place_id       =>place_id,
                      :lat            =>lat,
                      :lng            =>lng,
                      :created_on     =>date)

      end
    end
	end
	
  def made_spend_engagement_at(qr_code, business, spend_campaign , ringup_amount, lat, lng, log_group, issued_by) 
    #begin
      if spend_campaign.present?
        engagement=spend_campaign.engagements.first
        result=engaged_with(engagement,ringup_amount * engagement.amount,qr_code,nil,lat,lng,"User made a spend based engagement through cashier",1,log_group, issued_by) 
        #self.receipts.create(:business_id=>spend_campaign.program.business.id, :place_id=>result[:place_id], :receipt_text=>"", :amount=>result[:after_fees_amount], :receipt_type=>Receipt::TYPE[:spend], :transaction_id=>result[:transaction].id, :log_group_id=>result[:log_group].id, :spend_campaign_id=>spend_campaign.id)
        receipt=Receipt.create(:user_id=>self.id, :cashier_id=>issued_by, :receipt_text=>"", :receipt_type=>Receipt::TYPE[:spend], :transaction_id=>result[:transaction].id, :log_group_id=>result[:log_group].id)
        self.receipts << receipt
        self.pending_receipts << receipt
        save
      end
      result
    #rescue Exception=>e
    #  logger.error "Exception #{e.class}: #{e.message}"
    #end
  end

  def create_load_transaction_receipt(cashier_id, txn_id)
    receipt = Receipt.create(:user_id => self.id, :cashier_id => cashier_id, :receipt_text=>"Load receipt", :receipt_type=>Receipt::TYPE[:load], :transaction_id => txn_id)
    self.receipts << receipt
    self.pending_receipts << receipt
    save
  end

  def create_charge_transaction_receipt(cashier_id, txn_id)
    receipt = Receipt.create(:user_id => self.id, :cashier_id => cashier_id, :receipt_text=>"Charge receipt", :receipt_type=>Receipt::TYPE[:spend], :transaction_id => txn_id)
    self.receipts << receipt
    self.pending_receipts << receipt
    save
  end

  def create_charge_transaction_group_receipt(cashier_id, txn_group_id)
    receipt = Receipt.create(:user_id => self.id, :cashier_id => cashier_id, :receipt_text=>"Charge receipt", :receipt_type=>Receipt::TYPE[:spend], :transaction_group_id => txn_group_id)
    self.receipts << receipt
    self.pending_receipts << receipt
    save
  end
  
  
	def ensure_authentication_token!
    reset_authentication_token! if authentication_token.blank?
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def engaged_with_business?(business)
    self.business_customers.where(:business_id=>business.id).size > 0
  end

  def is_targeted_from?(campaign)
    campaign.targets.each do |target|
      return target.name=="new_comers" ? !self.engaged_with_business?(campaign.program.business) : self.engaged_with_business?(campaign.program.business)
    end
  end

  def is_engaged_with_campaign?(campaign)
    !self.logs.where(:campaign_id=>campaign.id).limit(1).empty?
  end

  def system_id
    self.qr_code.try(:hash_code)
  end

  def issue_qrcode(issued_by, size, code_type)
    QrCode.create(:issued_by=>issued_by, :size=>size, :code_type=>code_type, :associatable_id=>self.id, :associatable_type=>QrCode::USER_TYPE, :status=>true)
  end

  # new function to set the password without knowing the current password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    unless_confirmed {yield}
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end


  def list_customer_pending_receipts
    self.pending_receipts
        .joins("inner join transactions on (transactions.id = receipts.transaction_id or transactions.transaction_group_id = receipts.transaction_group_id)")
        .joins("inner join logs on logs.transaction_id = transactions.id")
        .joins("INNER JOIN businesses ON businesses.id = logs.business_id ")
        .joins("LEFT OUTER join brands on brands.id = businesses.brand_id")
        .joins("LEFT OUTER join log_groups on log_groups.id = receipts.log_group_id")
        .joins("LEFT OUTER JOIN campaigns on campaigns.id = logs.campaign_id")
        .joins("LEFT OUTER JOIN engagements on engagements.campaign_id = campaigns.id")
        .joins("LEFT OUTER JOIN places ON logs.place_id = places.id")
        .select("businesses.id as business_id, transactions.to_account_balance_after as current_balance, transactions.after_fees_amount as earned_points, (transactions.after_fees_amount / engagements.amount) as spend_money, brands.id as brand_id, engagements.fb_engagement_msg, campaigns.id as campaign_id, logs.user_id, receipts.log_group_id, receipts.receipt_text, receipts.receipt_type, receipts.transaction_id, receipts.created_at as date_time, places.name as place_name, brands.name as brand_name")
        .where("logs.transaction_id = receipts.transaction_id")
  end
  
  def list_customer_all_receipts(business_id)
    filters = []
    params  = []
    filters << "businesses.id = ?" and params << business_id if business_id.present?
    params.insert(0, filters.join(" AND ")) 
    them = self.receipts
        .joins("inner join transactions on (transactions.id = receipts.transaction_id or transactions.transaction_group_id = receipts.transaction_group_id)")
        .joins("inner join logs on logs.transaction_id = transactions.id")
        .joins("INNER JOIN businesses ON businesses.id = logs.business_id ")
        .joins("LEFT OUTER join brands on brands.id = businesses.brand_id")
        .joins("LEFT OUTER join log_groups on log_groups.id = receipts.log_group_id")
        .joins("LEFT OUTER JOIN campaigns on campaigns.id = logs.campaign_id")
        .joins("LEFT OUTER JOIN engagements on engagements.campaign_id = campaigns.id")
        .joins("LEFT OUTER JOIN places ON logs.place_id = places.id")
        .select("businesses.id as business_id, transactions.to_account_balance_after as current_balance, transactions.after_fees_amount as earned_points, (transactions.after_fees_amount / engagements.amount) as spend_money, brands.id as brand_id, engagements.fb_engagement_msg, campaigns.id as campaign_id, logs.user_id, receipts.log_group_id, receipts.receipt_text, receipts.receipt_type, receipts.transaction_id, receipts.created_at as date_time, places.name as place_name, brands.name as brand_name")
        .where(params)
  end

  def list_cashier_receipts(limit)
    Receipt.joins("inner join transactions on (transactions.id = receipts.transaction_id or transactions.transaction_group_id = receipts.transaction_group_id)")
           .joins("inner join logs on logs.transaction_id = transactions.id")
           .joins("INNER JOIN businesses ON businesses.id = logs.business_id ")
           .joins("LEFT OUTER join brands on brands.id = businesses.brand_id")
           .joins("LEFT OUTER join log_groups on log_groups.id = receipts.log_group_id")
           .joins("LEFT OUTER JOIN campaigns on campaigns.id = logs.campaign_id")
           .joins("LEFT OUTER JOIN engagements on engagements.campaign_id = campaigns.id")
           .joins("LEFT OUTER JOIN places ON logs.place_id = places.id")
           .select("#{self.id} as customer_id, businesses.id as business_id, transactions.to_account_balance_after as current_balance, transactions.after_fees_amount as earned_points, (transactions.after_fees_amount / engagements.amount) as spend_money, brands.id as brand_id, engagements.fb_engagement_msg, campaigns.id as campaign_id, logs.user_id, receipts.log_group_id, receipts.receipt_text, receipts.receipt_type, receipts.transaction_id, receipts.created_at as date_time, places.name as place_name, brands.name as brand_name")
           .where("cashier_id= #{self.id} and logs.transaction_id = receipts.transaction_id")
           .order('receipts.created_at DESC')
           .limit(limit)
           #.where("receipts.created_at #{((no_of_days-1).days.ago.utc...Time.now.utc).to_s(:db)} and logs.transaction_id = receipts.transaction_id and receipts.cashier_id= #{self.id}")
  end
  
  def engaged(engagement)
    #depending on the type do
  end


  def share_link
    self.id.alphadecimal
  end

  def self.find_by_share_id(short_id)
    where(:id=>short_id.alphadecimal).limit(1).first
  end

  def update_share_sign_up_count
    self.sign_up_count +=1
    self.save!
  end
  
  ALL=3
  USER_IDS_BASED=1
  NON_USER_IDS_BASED=2
  
  def all_transactions(options)
    filters = []
    params  = []
    filters << "businesses.id = ?"             and params << options[:business_id] unless options[:business_id].nil?
    if !options[:from_date].nil? and !options[:to_date].nil?
      filters << "Date(logs.created_at) >= ?"  and params << options[:from_date]
      filters << "Date(logs.created_at) <= ?"  and params << options[:to_date]
    elsif options[:from_date]
      filters << "Date(logs.created_at) >= ?"   and params << options[:from_date]
    elsif options[:to_date]
      filters << "Date(logs.created_at) <= ?"   and params << options[:to_date]
    end
    params.insert(0, filters.join(" AND ")) 
    conditions=""
    if options[:filters]==USER_IDS_BASED
      conditions = "qr_codes.associatable_type = 'User'"
    elsif options[:filters]==NON_USER_IDS_BASED
      conditions = "qr_codes.associatable_type != 'User'"
    end
    self.logs.joins(:transaction)
             .joins("LEFT OUTER JOIN places ON logs.place_id=places.id LEFT OUTER JOIN businesses ON businesses.id=logs.business_id LEFT OUTER JOIN users ON logs.issued_by=users.id INNER JOIN qr_codes ON logs.qr_code_id=qr_codes.id")             
             .select("businesses.id as business_id, logs.issued_by as issued_by, logs.lat, logs.lng, logs.id as log_id, qr_codes.id as qr_code_id, qr_codes.hash_code, logs.created_at, businesses.name as bname, places.name as pname, CONCAT(users.first_name,' ', users.last_name) as scanned_by, logs.gained_amount, users.id as user_id")
             .order("logs.created_at DESC")  
             .where(params)
             .where(conditions)
               
  end
  
  def set_legal_ids(legal_types, legal_ids)
    legal_types.each_with_index do |legal_type_id, index|
      if legal_ids[index].present? and legal_type_id.present?
        LegalId.find_or_create_by_legal_type_id_and_associatable_id_and_associatable_type(:id_number=>legal_ids[index],:associatable_id=>self.id,:associatable_type=>"User",:legal_type_id=>legal_type_id)
      end
    end
  end

  def country_code
    self.try(:country).try(:phone_country_code)||''
  end
  
  def add_country_code_to_phone
    if !self.telephone_number.blank?
      code = country_code
      phone_number = self.telephone_number
      unless phone_number.starts_with?(code)
        self.telephone_number = code + phone_number
      end
    end
  end

  def phone_without_code
    phone_number = self.telephone_number
    return '' if !phone_number
    code = country_code
    phone_number.gsub(/^#{Regexp.escape(code)}/, '')
  end

  protected

  def ensure_account_holder!
    self.create_account_holder if account_holder.blank?
  end
end
