class Users::PlacesController < Users::BaseController
  def index
    @places=[] 
    is_my_city=false
    if !params[:city_id].blank?#given specific city listing all places at that city
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
    elsif !params[:lat].blank? && !params[:long].blank?
      #Get Nearest City
      city    = City.closest(:origin=>[params[:lat].to_f,params[:long].to_f]).first
      @places = Place.with_address.within(DISTANCE,:units=>Place::DISTANCE_UNIT.to_sym,:origin=>[params[:lat].to_f,params[:long].to_f]).order("distance ASC") #List nearby places
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
      @result["places"][index] = place.attributes.reject{|k,v| k=="address_id"}
      @result["places"][index]["distance-unit"] =Place::DISTANCE_UNIT
      business=place.business
      @result["places"][index]["user-id-image-url"]=current_user.qr_code && business.activate_users_id ? URI.escape(current_user.qr_code.qr_code_image.photo.url) : nil
      unless business.nil?
        programs=business.programs
        currency_symbol=ISO4217::Currency.from_code(business.currency_code).symbol if business.currency_code.present?
        @result["places"][index]["brand-name"]    =business.try(:brand).try(:name)
        @result["places"][index]["brand-image"]   =business.try(:brand).try(:brand_image).nil? ? nil : URI.escape(business.brand.brand_image.photo.url(:normal)) 
        @result["places"][index]["brand-image-fb"]=business.try(:brand).try(:brand_image).nil? ? nil : URI.escape(business.brand.brand_image.photo.url(:thumb))
        @result["places"][index]["is_open"]       =place.is_open?
        @result["places"][index]["open-hours"]    =place.open_hours.collect{|oh| {:from=>oh.from.strftime("%I:%M %p"),:to=>oh.to.strftime("%I:%M %p"),:day=>OpenHour::DAYS.key(oh.day_no)}}
        @result["places"][index]["business_has_user_id_card"]    =business.try(:activate_users_id)
        @result["places"][index]["images"]        =[]
        place.place_images.each_with_index do |p_image,i|
          @result["places"][index]["images"][i]={"image-thumb-url"=>URI.escape(p_image.photo.url(:thumb)),"image-url"=>URI.escape(p_image.photo.url(:normal))}          
        end
        @result["places"][index]["accounts"]      =[]
        @result["places"][index]["rewards"]       =[]
        unless targeted_campaigns.empty?
          results=programs.joins(:campaigns=>[:rewards,:places,:accounts=>[:measurement_type,:account_holder]])
                          .select("rewards.id as reward_id,rewards.name,rewards.heading1,rewards.heading2,rewards.fb_unlock_msg,rewards.fb_enjoy_msg,rewards.legal_term,rewards.max_claim,rewards.max_claim_per_user,rewards.needed_amount,rewards.reward_money_amount,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id and users_enjoyed_rewards.user_id=#{current_user.id}) As redeemCount,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id) As numberOfRedeems,account_holders.model_id,account_holders.model_type,accounts.campaign_id,accounts.amount,accounts.is_money,measurement_types.name as measurement_type")
                          .where("campaigns.id IN (#{targeted_campaigns.join(',')}) and account_holders.model_id=#{current_user.id} and account_holders.model_type='User' and ((campaigns.end_date IS NOT null AND '#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date) || '#{Date.today}' >= campaigns.start_date) and campaigns_places.place_id=#{place.id} and rewards.is_active=true and accounts.status=true")
                           
          results.each_with_index do |result,i|
            @result["places"][index]["accounts"] << result.attributes.select {|key, value| key == "amount" || key=="campaign_id" || key=="is_money" || key=="measurement_type"}
            attributes=result.attributes
            reward_obj=Reward.find(result.reward_id)
            reward_campaign=reward_obj.campaign
            if (attributes["max_claim_per_user"].nil? || attributes["max_claim_per_user"]=="0"|| attributes["redeemCount"].to_i < attributes["max_claim_per_user"].to_i) and (attributes["max_claim"].nil? || attributes["max_claim"]=="0" || attributes["numberOfRedeems"].to_i < attributes["max_claim"].to_i)  
              @result["places"][index]["rewards"][i] = attributes.reject {|k,v| k == "amount"  || k=="is_money" || k == "model_id" || k=="model_type" || k=="measurement_type" || k=="reward_money_amount"}
              if @result["places"][index]["rewards"][i].present?
                reward_image=reward_obj.reward_image
                @result["places"][index]["rewards"][i]["reward-image"]   =reward_image.nil? ? nil : URI.escape(reward_image.photo.url(:normal))
                @result["places"][index]["rewards"][i]["reward-image-fb"]=reward_image.nil? ? nil : URI.escape(reward_image.photo.url(:thumb))
                if reward_campaign.spend_campaign?
                  points_rate=reward_campaign.engagements.first.try(:amount)
                  @result["places"][index]["rewards"][i]["points_rate"]=points_rate
                  @result["places"][index]["rewards"][i]["reward_money_amount"]=reward_obj.reward_money_amount * points_rate if reward_obj.reward_money_amount.present?
                  @result["places"][index]["rewards"][i]["reward_currency_symbol"]=currency_symbol
                  @result["places"][index]["rewards"][i]["expiry_date"]=reward_campaign.engagements.first.try(:end_date)
                end
                how_to_get_amount_text=""  
                @result["places"][index]["rewards"][i]["how_to_get_amount"]=reward_obj.campaign.engagements.collect{|eng| how_to_get_amount_text+="#{eng.name} gets you #{eng.amount} #{attributes["measurement_type"]}\n"}.first
              end 
            end
          end #end_of_each_with_index
        end
      end
    end
    @result
  end
  def add_my_phone
    if current_user.update_attributes(:telephone_number=>params[:phone_number])
      respond_to do |format|
			  format.xml { render :xml =>current_user.to_xml(:only=>[:id,:telephone_number]),:status=>200 }
		  end
    else
      respond_to do |format|
        error_text=current_user.errors.on(:telephone_number) ? "ERROR:Invalid phone number. Your phone number should start with 00 or + then the country code then the rest of your phone number." : "ERROR:Something went wrong on server"
			  format.xml { render :text => error_text,:status=>200 }
		  end
    end
  end
  
  def get_my_id
    #TODO implement params[:business_id] when user has various qrcodes at businesses
    qr_code=current_user.qr_code
    result={}
    result[:user_id_image_url]=qr_code.try(:qr_code_image).try(:photo).try(:url)
    result[:starting_timer_seconds ]=STARTING_TIMER_SEC
    respond_to do |format|       
      format.xml { render :xml => result,:status=>200 }
    end
  end
  
  def get_my_receipts
    all_receipts=current_user.receipts.join([:business,:place]).select("receipts.*, places.name, businesses.name")
    respond_to do |format|       
      format.xml { render :xml => all_receipts.to_xml,:status=>200 }
    end
  end
end
