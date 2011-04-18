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
	    	@result["places"][index]["business-name"]=business.name
	    	@result["places"][index]["accounts"]=[]
				accounts=programs.joins(:campaigns=>[:accounts=>:account_holder]).select("accounts.campaign_id,accounts.amount,accounts.measurement_type_id").where("account_holders.model_id=#{current_user.id} && (#{Date.today} > campaigns.start_date && #{Date.today} < campaigns.end_date)")
				accounts.each do |account|
					@result["places"][index]["accounts"] << account.attributes
				end
				@result["places"][index]["rewards"]=[] 
				normal_rewards=programs.joins(:campaigns=>:rewards).select("rewards.*,((SELECT amount FROM accounts WHERE campaign_id=rewards.campaign_id AND accounts.account_holder_id=#{current_user.account_holder.id}) >= rewards.needed_amount) As unlocked,(SELECT count(*) from logs where logs.reward_id=rewards.id and logs.user_id=#{current_user.id}) As redeemCount").where("#{Date.today} > campaigns.start_date && #{Date.today} < campaigns.end_date")
				normal_rewards.each do |reward|
					attributes=reward.attributes
					if attributes["redeemCount"].to_i < attributes["claim"].to_i 
						@result["places"][index]["rewards"] << attributes
					end
				end
			end
		end
		@result
  end
  
end
