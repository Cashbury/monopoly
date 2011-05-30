class Users::PlacesController < Users::BaseController
  def index
    @places=[] 
    is_my_city=false
    if params[:city_id] #given specific city listing all places at that city
      city= City.closest(:origin=>[params[:lat].to_f,params[:long].to_f]).first
      if city.id == params[:city_id]
        @places=Place.with_address.geo_scope(:origin=>[params[:lat].to_f,params[:long].to_f])
                                  .where("cities.id=#{params[:city_id]}")
                                  .order("distance ASC")
        is_my_city=!city.nil?                                  
      else
        city=City.where(:id=>params[:city_id]).first
        @places=Place.with_address.where("cities.id=#{params[:city_id]}").order("places.name ASC")                                  
      end                             
    elsif params[:lat] && params[:long]
      #Get Nearest City
      city    = City.closest(:origin=>[params[:lat].to_f,params[:long].to_f]).first
      @places = Place.with_address.within(DISTANCE,:units=>:km,:origin=>[params[:lat].to_f,params[:long].to_f]).order("distance ASC") #List nearby places
      #List all city places order by distance ASC if no nearby places
      @places = Place.with_address.geo_scope(:origin=>[params[:lat].to_f,params[:long].to_f])
                                  .where("cities.id=#{city.id}")
                                  .order("distance ASC") if @places.empty?
      is_my_city=!city.nil?
    else #default is San Fransisco all places
      city   =City.find_by_name("San Francisco")
      @places=Place.with_address.where("cities.id=#{city.id}").order("places.name ASC")
    end
    unless params[:keywords].blank?
      keys=params[:keywords].split(/[^A-Za-z0-9_\-]+/)
      matched_places=[]
      Business.tagged_with(keys,:any=>true).collect{|b| matched_places +=b.places}
      temp_places = Place.tagged_with(keys,:any=>true).with_address
      matched_places = matched_places | temp_places # merging places resulted from Business matched tags with Places matched tags
      @places= @places & matched_places # Intersection
    end
    targeted_campaigns=current_user.auto_enroll_at(@places)
    respond_to do |format|
      format.xml { render :xml => prepare_result(@places,is_my_city,city,targeted_campaigns) }
    end
  end
  
  def list_all_cities
    @cities=City.order("name ASC").select("cities.name,cities.id")
    respond_to do |format|
      format.xml { render :xml => @cities }
    end
  end
  
  def prepare_result(places,is_my_city,city,targeted_campaigns)
    @result={}
    @result["is_my_city"]=is_my_city
    if city
      @result["city-id"]  =city.id
      @result["city-name"]=city.name
    end
    @result["places"]=[]
    places.each_with_index do |place,index|
      @result["places"][index] = place.attributes.reject{|k,v| k=="address_id" || k=="distance"}
      business=place.business
      unless business.nil?
        programs=business.programs
        @result["places"][index]["brand-name"]    =business.try(:brand).try(:name)
        @result["places"][index]["brand-image"]   =business.try(:brand).try(:brand_image).nil? ? nil : URI.escape(business.brand.brand_image.photo.url(:normal)) 
        @result["places"][index]["brand-image-fb"]=business.try(:brand).try(:brand_image).nil? ? nil : URI.escape(business.brand.brand_image.photo.url(:thumb))
        @result["places"][index]["is_open"]       =place.is_open?
        @result["places"][index]["open-hours"]    =place.open_hours.collect{|oh| {:from=>oh.from.strftime("%I:%M %p"),:to=>oh.to.strftime("%I:%M %p"),:day=>OpenHour::DAYS.key(oh.day_no)}}
        @result["places"][index]["accounts"]      =[]
        @result["places"][index]["rewards"]       =[]
        results=programs.joins(:campaigns=>[:rewards,:places,:accounts=>[:measurement_type,:account_holder]])
                        .select("rewards.id as reward_id,rewards.name,rewards.heading1,rewards.heading2,rewards.legal_term,rewards.max_claim,rewards.max_claim_per_user,rewards.needed_amount,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id and users_enjoyed_rewards.user_id=#{current_user.id}) As redeemCount,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id) As numberOfRedeems,account_holders.model_id,account_holders.model_type,accounts.campaign_id,accounts.amount,accounts.is_money,measurement_types.name as measurement_type")
                        .where("campaigns.id IN (#{targeted_campaigns.join(',')}) and account_holders.model_id=#{current_user.id} and account_holders.model_type='User' and ((campaigns.end_date IS NOT null AND '#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date) || '#{Date.today}' >= campaigns.start_date) and campaigns_places.place_id=#{place.id}")
                         
        results.each_with_index do |result,i|
          @result["places"][index]["accounts"] << result.attributes.select {|key, value| key == "amount" || key=="campaign_id" || key=="is_money" || key=="measurement_type"}
          attributes=result.attributes
          reward_obj=Reward.find(result.reward_id)
          if (attributes["max_claim_per_user"].nil? || attributes["max_claim_per_user"]=="0"|| attributes["redeemCount"].to_i < attributes["max_claim_per_user"].to_i) and (attributes["max_claim"].nil? || attributes["max_claim"]=="0" || attributes["numberOfRedeems"].to_i < attributes["max_claim"].to_i)  
            @result["places"][index]["rewards"][i] = attributes.reject {|k,v| k == "amount"  || k=="is_money" || k == "model_id" || k=="model_type" || k=="measurement_type"}
            if @result["places"][index]["rewards"][i].present?
              reward_image=reward_obj.reward_image
              @result["places"][index]["rewards"][i]["reward-image"]   =reward_image.nil? ? nil : URI.escape(reward_image.photo.url(:normal))
              @result["places"][index]["rewards"][i]["reward-image-fb"]=reward_image.nil? ? nil : URI.escape(reward_image.photo.url(:thumb))
              how_to_get_amount_text=""  
              @result["places"][index]["rewards"][i]["how_to_get_amount"]=reward_obj.campaign.engagements.collect{|eng| how_to_get_amount_text+="#{eng.name} gets you #{eng.amount} #{attributes["measurement_type"]}\n"}.first
            end 
          end
        end
      end
    end
    @result
  end
  
end
