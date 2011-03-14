class UsersSnap < ActiveRecord::Base
	belongs_to :user
	belongs_to :qr_code
	
	validates_uniqueness_of :qr_code_id,:if=>:check_qrcode_type
	
	def check_qrcode_type
		qrcode=QrCode.find_by_id(self.qr_code_id)
		!qrcode.code_type.nil? && qrcode.code_type==false unless qrcode.nil? 
	end
            
  cattr_reader :per_page
  @@per_page = 20
  
  def self.search(options)
    @filters = []
    @params  = []
    @filters << "businesses.id = ?" and @params << options[:business_id] unless options[:business_id].nil?
    @filters << "places.id = ?"     and @params << options[:place_id]    unless options[:place_id].nil?
    @filters << "used_at >= ?"      and @params << options[:start_date]  unless options[:start_date].nil?
    @filters << "used_at <= ?"      and @params << options[:end_date]    unless options[:end_date].nil?
    @params.insert(0, @filters.join(" AND ")) 
    @results = UsersSnap.select("user_id,qr_code_id,used_at,businesses.id,places.id,engagements.name as ename,businesses.name as bname,point,places.name as pname,users.full_name,programs.name as program_name")
    									  .joins([:user,:qr_code=>[:engagement=>:program,:place=>:business]])
    									  .where(@params)
    									  .order("users.full_name DESC")
    									  .paginate(:page => options[:page],:per_page => per_page )
    return @results
    
  end        
end
