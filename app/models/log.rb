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
end
