class UsersSnaps < ActiveRecord::Base
	belongs_to :user
	belongs_to :qr_code
	
	validates :qr_code_id,
            :uniqueness => true,
            :allow_nil => false,:if=>:check_qrcode
            
 def check_qrcode
 		qr_code=QrCode.find_by_id(self.qr_code_id)
 		qr_code.code_type==QrCode::SINGLE_USE unless qr_code.blank?
 end
    
 cattr_reader :per_page
 @@per_page = 10
  
 def self.search(options)
    @filters = []
    @params = []
    @filters << "businesses.id = ?" and @params << options[:business_id] unless options[:business_id].nil?
    @filters << "places.id = ?" and @params << options[:place_id] unless options[:place_id].nil?
    @filters << "used_at = ?" and @params << options[:time] unless options[:time].nil?
    @params.insert(0, @filters.join(" AND ")) 
    @results = UsersSnaps.select("user_id,qr_code_id,used_at,businesses.id,places.id,engagements.name as ename,businesses.name as bname,point,places.name as pname,users.full_name")
    										 .joins([:user,:qr_code=>{:engagement=>{:places=>:business}}])
    										 .where(@params)
    										 .order(options[:sort_by].blank? ? "user_id DESC" : "#{options[:sort_by]} #{options[:sort_direction]}")
    										 .paginate(:page => options[:page],:per_page => per_page ) 									 
                         
    @count = UsersSnaps.count
    
    return @results, ( @count + @@per_page - 1 ) / @@per_page
    
  end        
end
