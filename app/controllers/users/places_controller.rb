class Users::PlacesController < Users::BaseController

  def index
    @places=[] 
    unless params[:long].blank? && params[:lat].blank?
			@places = Place.within(DISTANCE,:units=>:km,:origin=>[params[:lat].to_f,params[:long].to_f]).order('distance ASC')
	  else
	  	@places = Place.order("name desc")
    end
    unless params[:keywords].blank?
			keys=params[:keywords].split(/[^A-Za-z0-9_\-]+/)
	  	matched_places=[]
	  	Business.tagged_with(keys,:any=>true).collect{|b| matched_places +=b.places}
	  	temp_places = Place.tagged_with(keys,:any=>true)
	  	matched_places = matched_places | temp_places # merging places resulted from Business matched tags with Places matched tags
	  	@places= @places & matched_places # Intersection
	  end
    current_user.auto_enroll_at(@places)
    respond_to do |format|
      format.xml { render :xml => prepare_result(@places) }
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
	    	@result["places"][index]["brand-name"]=business.brand.name
	    	@result["places"][index]["brand-image"]=business.brand.brand_image.nil? ? nil : business.brand.brand_image.photo.url(:thumb) 
	    	@result["places"][index]["is_open"]   =place.is_open?
	    	@result["places"][index]["open-hours"]=place.open_hours.collect{|oh| {:from=>oh.from.strftime("%I:%M %p"),:to=>oh.to.strftime("%I:%M %p"),:place_id=>oh.place_id,:day=>OpenHour::DAYS.index(oh.day_no)}}
	    	@result["places"][index]["accounts"]  =[]
				accounts=programs.joins(:campaigns=>[:accounts=>:account_holder])
				                 .select("accounts.campaign_id,accounts.amount,accounts.measurement_type_id")
				                 .where("account_holders.model_id=#{current_user.id} && ('#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date)")
				accounts.each do |account|
					@result["places"][index]["accounts"] << account.attributes
				end
				@result["places"][index]["rewards"]=[] 
				normal_rewards=programs.joins(:campaigns=>:rewards)
				                       .select("rewards.*,((SELECT amount FROM accounts WHERE campaign_id=rewards.campaign_id AND accounts.account_holder_id=#{current_user.account_holder.id}) >= rewards.needed_amount) As unlocked,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id and users_enjoyed_rewards.user_id=#{current_user.id}) As redeemCount,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id) As numberOfRedeems")\
				                       .where("'#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date")
				normal_rewards.each do |reward|
					attributes=reward.attributes
					if attributes["redeemCount"].to_i < attributes["max_claim_per_user"].to_i && attributes["numberOfRedeems"].to_i < attributes["max_claim"].to_i  
						@result["places"][index]["rewards"] << attributes
					end
				end
			end
		end
		@result
  end
  
end
