class Users::PlacesController < Users::BaseController
  def index
    @places=[] 
    is_my_city=false
    if params[:city_id] #given specific city listing all places at that city
      @places=  Place.with_address.where("addresses.city_id=#{params[:city_id]}")
    elsif params[:lat] && params[:long]
      @places = Place.with_address.within(DISTANCE,:units=>:km,:origin=>[params[:lat].to_f,params[:long].to_f])
      city=@places.first.try(:address).try(:city) unless @places.empty?
      is_my_city=!city.nil?
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
      business=place.business
      unless business.nil?
        programs=business.programs
        @result["places"][index]["brand-name"]    =business.brand.name
        @result["places"][index]["brand-image"]   =business.brand.brand_image.nil? ? nil : URI.escape(business.brand.brand_image.photo.url(:normal)) 
        @result["places"][index]["brand-image-fb"]=business.brand.brand_image.nil? ? nil : URI.escape(business.brand.brand_image.photo.url(:thumb))
        @result["places"][index]["is_open"]       =place.is_open?
        @result["places"][index]["open-hours"]    =place.open_hours.collect{|oh| {:from=>oh.from.strftime("%I:%M %p"),:to=>oh.to.strftime("%I:%M %p"),:day=>OpenHour::DAYS.key(oh.day_no)}}
        @result["places"][index]["accounts"]      =[]
        accounts=programs.joins(:campaigns=>[:places,:accounts=>[:measurement_type,:account_holder]])
                         .select("account_holders.model_id,account_holders.model_type,accounts.campaign_id,accounts.amount,accounts.is_money,measurement_types.name as measurement_type,campaigns.start_date,campaigns.end_date")
                         .where("campaigns.id IN (#{targeted_campaigns.join(',')}) and account_holders.model_id=#{current_user.id} and account_holders.model_type='User' and ((campaigns.end_date IS NOT null AND '#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date) || '#{Date.today}' >= campaigns.start_date) and campaigns_places.place_id=#{place.id}")
        accounts.each do |account|
          @result["places"][index]["accounts"] << account.attributes.reject {|key, value| key == "model_id" || key=="model_type" || key=="start_date" || key=="end_date"}
        end
        @result["places"][index]["rewards"]=[] 
        normal_rewards=programs.joins(:campaigns=>[:rewards,:places,:measurement_type])
                               .select("rewards.*,rewards.id as reward_id,measurement_types.name as measurement_name,((SELECT amount FROM accounts WHERE campaign_id=rewards.campaign_id AND accounts.account_holder_id=#{current_user.account_holder.id}) >= rewards.needed_amount) As unlocked,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id and users_enjoyed_rewards.user_id=#{current_user.id}) As redeemCount,(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id) As numberOfRedeems")
                               .where("campaigns.id IN (#{targeted_campaigns.join(',')}) and ((campaigns.end_date IS NOT null and '#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date) || '#{Date.today}' >= campaigns.start_date) and campaigns_places.place_id=#{place.id}")                               
        normal_rewards.each_with_index do |reward,i|
          attributes=reward.attributes
          reward_obj=Reward.find(reward.reward_id)
          if (attributes["max_claim_per_user"].nil? || attributes["max_claim_per_user"]=="0"|| attributes["redeemCount"].to_i < attributes["max_claim_per_user"].to_i) and (attributes["max_claim"].nil? || attributes["max_claim"]=="0" || attributes["numberOfRedeems"].to_i < attributes["max_claim"].to_i)  
            @result["places"][index]["rewards"][i] = attributes.reject {|k,v| k=="created_at" || k=="updated_at" || k=="unlocked" || k=="start_date"}
            if @result["places"][index]["rewards"][i].present?
              @result["places"][index]["rewards"][i]["reward-image"]=reward_obj.reward_image.nil? ? nil : URI.escape(reward_obj.reward_image.photo.url(:normal))
              @result["places"][index]["rewards"][i]["reward-image-fb"]=reward_obj.reward_image.nil? ? nil : URI.escape(reward_obj.reward_image.photo.url(:thumb))
              how_to_get_amount_text=""  
              @result["places"][index]["rewards"][i]["how_to_get_amount"]=reward_obj.campaign.engagements.collect{|eng| how_to_get_amount_text+="#{eng.name} gets you #{eng.amount} #{attributes["measurement_name"]}\n"}.first
            end 
          end
        end
      end
    end
    @result
  end
  
end
