class UserAction < ActiveRecord::Base
	belongs_to :user
	belongs_to :qr_code
	belongs_to :business
	belongs_to :reward
	
	validates_uniqueness_of :qr_code_id,:if=>:check_qrcode_type
	
	scope :snaps_actions , where("user_actions.qr_code_id IS NOT NULL")
	scope :claim_rewards_actions , where("user_actions.reward_id IS NOT NULL")
	
	def check_qrcode_type
		qrcode=QrCode.find_by_id(self.qr_code_id)
		!qrcode.code_type.nil? && qrcode.code_type==false unless qrcode.nil? 
	end
            
  cattr_reader :per_page
  @@per_page = 20
  
  LIST_SNAPS=1
  LIST_TOP_LOYAL_CUSTOMERS=2
  
  def self.search(options)
    @filters = []
    @params  = []
    @filters << "businesses.id = ?"             and @params << options[:business_id] unless options[:business_id].nil?
    @filters << "places.id = ?"     						and @params << options[:place_id]    unless options[:place_id].nil?
    if !options[:from_date].nil? and !options[:to_date].nil?
    	@filters << "user_actions.used_at >= ?"  and @params << options[:from_date]
    	@filters << "user_actions.used_at <= ?"  and @params << options[:to_date]
    elsif options[:from_date]
			@filters << "user_actions.used_at = ?"  and @params << options[:from_date]
		elsif options[:to_date]
			@filters << "user_actions.used_at = ?"  and @params << options[:to_date]
    end
    @params.insert(0, @filters.join(" AND ")) 
    if options[:type]==LIST_SNAPS
	    @results = UserAction.snaps_actions
	    										 .select("user_actions.*,engagements.name as ename,businesses.name as bname,engagements.points,places.name as pname,users.full_name,programs.name as program_name")
	    									   .joins([:user,:qr_code=>[:engagement=>[:program=>[:business=>:places]]]])
	    									   .where(@params)
	    									   .order("user_actions.created_at DESC")
	    									   .paginate(:page => options[:page],:per_page => per_page )
    else
    	@results = UserAction.select("users.full_name,count(*) as total,businesses.name as bname,places.name as pname")
    									     .joins([:user,:business=>:places])
    									     .group(:user_id)
    									     .where(@params)
    									     .order("total DESC")
    									     .paginate(:page => options[:page],:per_page => per_page)
    end										  
    return @results
  end
end
