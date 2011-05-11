class Users::PlacesController < Users::BaseController
  include Geokit::Geocoders
  def index
    ##res=GoogleGeocoder.reverse_geocode([37.792821,-122.393992])
    ##res.city
    @places=[] 
    is_my_city=false
    if params[:city_id] #given specific city listing all places at that city
      @places=  Place.all_places.where("addresses.city_id=#{params[:city_id]}")
    elsif params[:lat] && params[:long]
      res=Geokit::Geocoders::MultiGeocoder.reverse_geocode([params[:lat],params[:long]])
      if res.city
        city=City.where(:name=>res.city).first
      elsif res.full_address
        keywords=res.full_address.downcase.chomp.split(",")
        query_string=""
        keywords.each_with_index do |k,index| 
          query_string+="lower(name) LIKE '%#{k.lstrip.rstrip}%'"
          query_string+=" OR " unless index==keywords.size-1
        end
        city=City.where(query_string).first
      end
      @places = city ? Place.within(DISTANCE,:units=>:km,:origin=>[params[:lat].to_f,params[:long].to_f]).all_places.where("addresses.city_id=#{city.id}") : Place.all_places 
      is_my_city=!city.nil?	               
	  else
	  	@places = Place.all_places
    end
    unless params[:keywords].blank?
			keys=params[:keywords].split(/[^A-Za-z0-9_\-]+/)
	  	matched_places=[]
	  	Business.tagged_with(keys,:any=>true).collect{|b| matched_places +=b.places}
	  	temp_places = Place.tagged_with(keys,:any=>true).joins(:address)
	  	matched_places = matched_places | temp_places # merging places resulted from Business matched tags with Places matched tags
	  	@places= @places & matched_places # Intersection
	  end
    current_user.auto_enroll_at(@places)
    respond_to do |format|
      format.xml { render :xml => prepare_result(@places,is_my_city) }
    end
  end
  
  def prepare_result(places,is_my_city)
  	@result={}
  	@result["is_my_city"]=is_my_city
  	@result["places"]=[]
    places.each_with_index do |place,index|
    	@result["places"][index] = place.attributes
    	business=place.business
    	unless business.nil?
	    	programs=business.programs
	    	@result["places"][index]["brand-name"]=business.brand.name
	    	@result["places"][index]["brand-image"]=business.brand.brand_image.nil? ? nil : business.brand.brand_image.photo.url(:thumb) 
	    	@result["places"][index]["is_open"]   =place.is_open?
	    	puts ">>>>>>>>place open hours size #{place.open_hours.size} and id =#{place.id}"
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
				                       .select("rewards.*,rewards.id as reward_id,((SELECT amount FROM accounts WHERE campaign_id=rewards.campaign_id AND accounts.account_holder_id=#{current_user.account_holder.id}) >= rewards.needed_amount) As unlocked,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id and users_enjoyed_rewards.user_id=#{current_user.id}) As redeemCount,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id) As numberOfRedeems")\
				                       .where("'#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date")				                       
				normal_rewards.each_with_index do |reward,i|
					attributes=reward.attributes
					if attributes["redeemCount"].to_i < attributes["max_claim_per_user"].to_i && attributes["numberOfRedeems"].to_i < attributes["max_claim"].to_i  
						@result["places"][index]["rewards"] << attributes
						reward_obj=Reward.find(reward.reward_id)
						@result["places"][index]["rewards"][i]["reward-image"]=reward_obj.reward_image.nil? ? nil : reward_obj.reward_image.photo.url(:thumb)
            how_to_get_amount_text=""  
						@result["places"][index]["rewards"][i]["how_to_get_amount"]=reward_obj.campaign.engagements.collect{|eng| how_to_get_amount_text+="#{eng.name} gets you #{eng.amount} amount\n"}.first 
					end
				end
			end
		end
		@result
  end
  
end
