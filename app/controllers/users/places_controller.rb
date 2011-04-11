class Users::PlacesController < Users::BaseController

  def index
    @places=[] 
    unless params[:long].blank? && params[:lat].blank?
			@places = Place.within(DISTANCE,:units=>:km,:origin=>[params[:lat].to_f,params[:long].to_f]).order('distance ASC')
	  else
	  	@places = Place.order("name desc")
    end
    unless params[:keywords].blank?
			keys=params[:keywords].split(' ')
	  	matched_places=[]
	  	Business.tagged_with(keys,:any=>true).collect{|b| matched_places +=b.places}
	  	temp_places = Place.tagged_with(keys,:any=>true)
	  	matched_places = matched_places | temp_places # merging places resulted from Business matched tags with Places matched tags
	  	@places= @places & matched_places # Intersection
	  end
    auto_enroll_user(@places)
    respond_to do |format|
      format.xml { render :xml => prepare_result(@places) }
    end
  end
  
  private
  def auto_enroll_user(places)
  	begin
			ids=places.collect{|p| p.business_id}
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
  
  def prepare_result(places)
  	@result={}
  	@result["places"]=[]
    places.each_with_index do |place,index|
    	@result["places"][index] = place.attributes
    	business=place.business
    	unless business.nil?
	    	programs=business.programs
	    	@result["places"][index]["business-name"]=business.name
	    	@result["places"][index]["accounts"]=[]
				accounts=programs.joins(:accounts).select("accounts.program_id,accounts.points").where("accounts.user_id=#{current_user.id}")
				accounts.each do |account|
					@result["places"][index]["accounts"] << account.attributes
				end
				@result["places"][index]["rewards"]=[] 
				normal_rewards=programs.joins(:rewards).select("rewards.*,((SELECT points FROM accounts WHERE program_id=rewards.program_id AND accounts.user_id=#{current_user.id}) >= rewards.points) As unlocked,(SELECT count(*) from user_actions where user_actions.reward_id=rewards.id and user_actions.user_id=#{current_user.id}) As redeemCount")
				normal_rewards.each do |reward|
					attributes=reward.attributes
					if attributes["redeemCount"].to_i < attributes["claim"].to_i 
						@result["places"][index]["rewards"] << attributes
					end
				end
				#@result["places"][index]["auto_unlock_rewards"]=[] 
				#unlock_rewards=rewards_attached_to_programs.where("rewards.auto_unlock=true")
				#unlock_rewards.each do |reward|
				#	unless current_user.is_engaged_to?(business.id)
				#		@result["places"][index]["auto_unlock_rewards"] << reward.attributes
				#	end
				#end
			end
		end
		@result
  end
  
  def user_not_engaged_with?(business_id)
  	current_user.user_actions.where(:business_id=>business_id).empty?
  end
  
end
