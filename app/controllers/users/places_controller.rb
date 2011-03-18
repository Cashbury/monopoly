class Users::PlacesController < Users::BaseController
	after_filter :auto_enroll_user
	
  def index
    @places = Place.all
    respond_to do |format|
      format.xml { render :xml => @places }
    end
  end
  
  def show
		@result={}
  	@result["places"]=[]
    @places=[] 
    unless params[:long].blank? and  params[:lat].blank?
			@places = Place.within(DISTANCE,:units=>:km,:origin=>[params[:lat].to_f,params[:long].to_f]).order('distance ASC')
	  else
	  	@places = Place.order("name desc")
    end
    @places.each_with_index do |place,index|
    	@result["places"] << place.attributes
    	@result["places"][index]["accounts"]=[]
			accounts=place.business.programs.joins(:accounts).select("accounts.program_id,accounts.points").where("accounts.user_id=#{current_user.id}")
			accounts.each do |account|
				@result["places"][index]["accounts"] << account.attributes
			end
			@result["places"][index]["rewards"]=[] 
			rewards=place.engagements.joins(:reward).select('rewards.*')
			normal_ones=rewards.where("rewards.auto_unlock=false")
			normal_ones.each do |reward|
				@result["places"][index]["rewards"] << reward.attributes
			end
			@result["places"][index]["auto_unlock_rewards"]=[] 
			unlock_ones=rewards.where("rewards.auto_unlock=true")
			unlock_ones.each do |reward|
				unless current_user.is_engaged_to?(place.business.id)
					@result["places"][index]["auto_unlock_rewards"] << reward.attributes
				end
			end
		end
    respond_to do |format|
      format.xml { render :xml => @result }
    end
  end
  
  private
  #This method should run within background job
  def auto_enroll_user
  	begin
			ids=@places.collect{|p| p.business_id}
			businesses=Business.where(:id=>ids)
			businesses.each do |business|
				business.programs.auto_enrolled_ones.each do |program|
					unless current_user.has_account_with_program?(program.id)
						Account.create!(:user_id=>current_user.id,:program_id=>program.id,:points=>program.initial_points)
					end
				end
			end
		rescue Exception=>e
			logger.error "Exception #{e.class}: #{e.message}"
		end
  end
  
  def user_not_engaged_with?(business_id)
  	current_user.user_actions.where(:business_id=>business_id).empty?
  end
  
end
