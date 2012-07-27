# == Schema Information
# Schema version: 20110615133925
#
# Table name: logs
#
#  id             :integer(4)      not null, primary key
#  user_id        :integer(4)
#  reward_id      :integer(4)
#  action_id      :string(255)
#  is_processed   :boolean(1)
#  place_id       :integer(4)
#  engagement_id  :integer(4)
#  business_id    :integer(4)
#  lat            :decimal(15, 10)
#  lng            :decimal(15, 10)
#  currency       :string(255)
#  gained_amount  :decimal(20, 3)
#  frequency      :decimal(20, 3)
#  amount_type    :string(255)
#  created_on     :date
#  log_group_id   :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#  transaction_id :integer(4)
#  campaign_id    :integer(4)
#

class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :place
	belongs_to :business
	belongs_to :engagement
	belongs_to :reward
	belongs_to :log_group
	belongs_to :transaction
	belongs_to :action
	belongs_to :qr_code
  belongs_to :campaign
  
	validates_numericality_of :gained_amount, :frequency, :lat, :lng ,:allow_nil => true
	
	LOG_ACTIONS={:engagement=>"Engagement", :redeem=>"Redeem"}
  SEARCH_TYPES={:engagements=>0,:top_loyal=>1}
  
	scope :engagements_logs, joins(:action).where("actions.name='#{LOG_ACTIONS[:engagement]}'")
	scope :redeems_logs, joins(:action).where("actions.name='#{LOG_ACTIONS[:redeem]}'")
            
  cattr_reader :per_page
  @@per_page = 20
  
  
  def self.search(options)
    @filters = []
    @params  = []
    @filters << "businesses.id = ?"             and @params << options[:business_id] unless options[:business_id].nil?
    @filters << "places.id = ?"                 and @params << options[:place_id]    unless options[:place_id].nil?
    if !options[:from_date].nil? and !options[:to_date].nil?
      @filters << "logs.created_on >= ?"  and @params << options[:from_date]
      @filters << "logs.created_on <= ?"  and @params << options[:to_date]
    elsif options[:from_date]
      @filters << "logs.created_on = ?"  and @params << options[:from_date]
    elsif options[:to_date]
      @filters << "logs.created_on = ?"  and @params << options[:to_date]
    end
    @params.insert(0, @filters.join(" AND ")) 
    if options[:type]==SEARCH_TYPES[:engagements]
      @results = Log.engagements_logs
                    .select("logs.*,engagements.name as ename,businesses.name as bname,engagements.amount,places.name as pname,users.first_name,users.last_name,program_types.name as program_name,campaigns.name as cname,measurement_types.name as amount_type")
                    .joins([:user,"LEFT OUTER JOIN places ON logs.place_id=places.id",:engagement=>[:campaign=>[:measurement_type,:program=>[:program_type,:business]]]])
                    .where(@params)
                    .order("logs.created_on DESC")
                    .paginate(:page => options[:page],:per_page => per_page )
    else
      @results = Log.engagements_logs
                    .select("users.first_name,users.last_name,count(*) as total,businesses.name as bname,places.name as pname")
                    .joins([:user,"LEFT OUTER JOIN places ON logs.place_id=places.id INNER JOIN businesses on logs.business_id = businesses.id"])
                    .group("logs.user_id",:place_id)
                    .where(@params)
                    .order("total DESC")
                    .paginate(:page => options[:page],:per_page => per_page)
    end                     
    return @results
  end
  
  
  def self.all_qrcodes_transactions(user_id)
    joins(:qr_code,:transaction)
    .joins("LEFT OUTER JOIN places ON logs.place_id=places.id LEFT OUTER JOIN businesses ON businesses.id=logs.business_id LEFT OUTER JOIN users ON logs.issued_by=users.id") 
    .where("qr_codes.associatable_id=#{user_id} and qr_codes.associatable_type='User'")
    .select("businesses.id as business_id, users.id as user_id, logs.lat, logs.lng, logs.id as log_id, qr_codes.id as qr_code_id, qr_codes.hash_code, logs.created_at, businesses.name as bname, places.name as pname, users.first_name, users.last_name, logs.gained_amount")
    .order("logs.created_at DESC")    
  end
  
  
  def self.latest_qrcode_transactions(qr_code_id)
    joins(:qr_code,:transaction)
    .joins("LEFT OUTER JOIN places ON logs.place_id=places.id LEFT OUTER JOIN businesses ON businesses.id=logs.business_id LEFT OUTER JOIN users ON logs.issued_by=users.id") 
    .where("qr_codes.id=#{qr_code_id}")
    .select("businesses.id as business_id, users.id as user_id, logs.lat, logs.lng, logs.id as log_id, qr_codes.id as qr_code_id, qr_codes.hash_code, logs.created_at, businesses.name as bname, places.name as pname, users.first_name, users.last_name, logs.gained_amount")
    .order("logs.created_at DESC")    
  end
  
  # 5 recent transactions from user's code
  def self.get_recent_transactions(user_id)
    joins(:qr_code,:transaction,:user)
    .joins("LEFT OUTER JOIN places ON logs.place_id=places.id LEFT OUTER JOIN businesses ON businesses.id=logs.business_id") 
    .where("qr_codes.associatable_id=#{user_id} and qr_codes.associatable_type='User'")
    .select("logs.id as log_id,logs.created_at, businesses.name as bname, places.name as pname, users.first_name, users.last_name, logs.gained_amount")
    .order("logs.created_at DESC")
    .limit(5)
  end
  
  
  def self.view_tx_details(log_id)
    joins([:action=>:transaction_type],:qr_code,:transaction,:user)
    .joins("LEFT OUTER JOIN places ON logs.place_id=places.id LEFT OUTER JOIN businesses ON businesses.id=logs.business_id")     
    .where("logs.id=#{log_id}")
    .select("transactions.id as transaction_id, transaction_types.name as log_type, qr_codes.status, users.first_name, users.last_name, transactions.from_account, transactions.to_account, transactions.from_account_balance_before, transactions.from_account_balance_after, transactions.to_account_balance_before, transactions.to_account_balance_after, logs.created_at, places.name as pname, transactions.note, transactions.after_fees_amount")
    .order("logs.created_at desc")
  end
  
  def self.list_campaign_transactions(c_id)
    joins(:campaign, :transaction,[:action=>:transaction_type])
    .joins("LEFT OUTER JOIN places ON logs.place_id=places.id LEFT OUTER JOIN businesses ON businesses.id=logs.business_id")     
    .where("campaigns.id=#{c_id}")
    .select("transactions.id as transaction_id, transaction_types.name as log_type, transactions.from_account, transactions.to_account, transactions.from_account_balance_before, transactions.from_account_balance_after, transactions.to_account_balance_before, transactions.to_account_balance_after, logs.created_at, places.name as pname, transactions.note, transactions.after_fees_amount")
    .order("logs.created_at desc")
  end
  
  
  def self.list_enrolled_customers(c_id,place_id)
    if place_id.present?
      engagements_logs
      .joins(:user,[:campaign=>[[:accounts=>:account_holder],:measurement_type]])
      .joins("INNER JOIN places ON logs.place_id=places.id")
      .select("places.name as p_name, count(*) as total, CONCAT(users.first_name,' ',users.last_name) as full_name, accounts.created_at as enrolled_since, accounts.amount, accounts.cumulative_amount, measurement_types.name as m_name, accounts.id as account_no ")
      .where("logs.campaign_id=#{c_id} and logs.place_id=#{place_id} and account_holders.model_id=users.id and account_holders.model_type='User'")
      .group("logs.user_id", :place_id)
      .order("total DESC")
    else
      engagements_logs
      .joins(:user,[:campaign=>[[:accounts=>:account_holder],:measurement_type]])
      .joins("LEFT OUTER JOIN places ON logs.place_id=places.id")
      .select("places.name as p_name, count(*) as total, CONCAT(users.first_name,' ',users.last_name) as full_name, accounts.created_at as enrolled_since, accounts.amount, accounts.cumulative_amount, measurement_types.name as m_name, accounts.id as account_no ")
      .where("logs.campaign_id=#{c_id} and account_holders.model_id=users.id and account_holders.model_type='User'")
      .group("logs.user_id")
      .order("total DESC")
    end
  
    #self.accounts.joins(:account_holder,:measurement_type)
    #             .joins("INNER JOIN users ON users.id= account_holders.model_id")
    #             .where("account_holders.model_type='User'")
    #             .select("(select count(*) from logs where users.id=logs.user_id and logs.campaign_id=#{c_id}) as total, CONCAT(users.first_name,' ',users.last_name) as full_name, accounts.created_at as enrolled_since, accounts.amount, accounts.cumulative_amount, measurement_types.name as m_name, accounts.id as account_no ")
    #             .order("total DESC")
  end


  def self.group_logs(&block)
    Log.transaction do
      log_grp = LogGroup.create!
      Log.log_group = log_grp
      block.call
      Log.log_group = nil
      log_grp
    end
  end

  def self.log_group
    Thread.current[:log_group]
  end

  def self.log_group=(log_grp)
    Thread.current[:log_group] = log_grp
  end

  def self.is_group_logs?
    Log.log_group.present?
  end
end
