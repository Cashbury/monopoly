class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :place
	belongs_to :business
	belongs_to :engagement
	belongs_to :reward
	belongs_to :log_group
	 
	validates_numericality_of :amount, :frequency, :lat, :lng ,:allow_nil => true
	
	LOG_TYPES={
	  :snap => :snap,
	  :redeem => :redeem
	}
	scope :snaps_logs, where(:log_type=>LOG_TYPES[:snap])
	scope :redeems_logs, where(:log_type=>LOG_TYPES[:redeem])
            
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
    if options[:type]==LOG_TYPES[:snap]
      @results = Log.snaps_logs
                    .select("logs.*,engagements.name as ename,businesses.name as bname,engagements.amount,places.name as pname,users.full_name,program_types.name as program_name,campaigns.name as cname,measurement_types.name as amount_type")
                    .joins([:user,"LEFT OUTER JOIN places ON logs.place_id=places.id",:engagement=>[:campaign=>[:measurement_type,:program=>[:program_type,:business]]]])
                    .where(@params)
                    .order("logs.created_on DESC")
                    .paginate(:page => options[:page],:per_page => per_page )
    else
      @results = Log.snaps_logs
                    .select("users.full_name,count(*) as total,businesses.name as bname,places.name as pname")
                    .joins([:user,"LEFT OUTER JOIN places ON logs.place_id=places.id INNER JOIN businesses on logs.business_id = businesses.id"])
                    .group(:user_id,:place_id)
                    .where(@params)
                    .order("total DESC")
                    .paginate(:page => options[:page],:per_page => per_page)
    end                     
    return @results
  end
end
