class Businesses::SpendCampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_business#, :except=>[:select_partial]
  
  def index
    program_type=ProgramType.find_or_create_by_name("Marketing")
    program=Program.where(:business_id=>@business.id,:program_type_id=>program_type.id).first
    @campaigns=program.nil? ? [] : program.campaigns.select {|c| c.engagements.size==1 && c.rewards.size==1}
    
    respond_to do |format|
      format.html
    end
  end
  
  def new
    #found=@business.programs.joins(:campaigns).where("campaigns.ctype=#{Campaign::CTYPE[:spend]}").select("campaigns.id").first
    #@campaign=found.nil? ? Campaign.new : Campaign.find(found.id)
    @campaign=Campaign.new
    @campaign.engagements.build
    @campaign.rewards.build
  end

  def create
    @program_type=ProgramType.find_or_create_by_name(:name=>"Marketing")
    @program     =Program.find_or_create_by_business_id_and_program_type_id(:business_id=>@business.id,:program_type_id=>@program_type.id)
    currency_symbol=@business.currency_symbol
    if params[:campaign][:start_date]=="" || (params[:campaign][:start_date]=="" and params[:launch_today]=="1")
      params[:campaign][:start_date]=Date.today.to_s
    end 
    @engagement_attrs=params[:campaign][:engagements_attributes]["0"]
    @reward_attrs=params[:campaign][:rewards_attributes]    
    if @reward_attrs["0"]["expiry_date"].present? and  @reward_attrs["0"]["expiry_date"].match(/\//)
      date_details1=@reward_attrs["0"]["expiry_date"].split("/").reverse
      expiry_date="#{date_details1[0]}-#{date_details1[2]}-#{date_details1[1]}"
    end
    if @engagement_attrs["end_date"].present? and @engagement_attrs["end_date"].match(/\//)
      date_details=@engagement_attrs["end_date"].split("/").reverse
      end_date="#{date_details[0]}-#{date_details[2]}-#{date_details[1]}"
    end
    params[:campaign][:engagements_attributes]["0"]["engagement_type_id"]=EngagementType.find_by_eng_type(EngagementType::ENG_TYPE[:spend]).id      
    params[:campaign][:engagements_attributes]["0"]["name"]="Spend Engagement"
    params[:campaign][:engagements_attributes]["0"]["end_date"]=end_date if end_date.present?
    @reward_attrs.each do |key,value| 
      description="Spend #{value["needed_amount"]}#{currency_symbol}"
      description << " before #{end_date}" if @engagement_attrs[:end_date].present?
      description << ", Get a #{"%0.2f" % value["money_amount"]}#{currency_symbol} Cash back"
      description << ", Offer available until #{expiry_date}" if @reward_attrs["0"]["expiry_date"].present?
      params[:campaign][:rewards_attributes][key]["heading2"]=description
      params[:campaign][:rewards_attributes][key]["needed_amount"]=value["needed_amount"].to_f * @engagement_attrs[:amount].to_f if value["needed_amount"].present?
      params[:campaign][:rewards_attributes][key]["name"]="$#{value[:money_amount]} Cash back"   
      params[:campaign][:rewards_attributes][key]["expiry_date"]=expiry_date if expiry_date.present?
    end
    @campaign=@program.campaigns.build(params[:campaign])
    @campaign.ctype=Campaign::CTYPE[:spend]
    @campaign.end_date=expiry_date.to_date if expiry_date.present? 
    if params[:target_id].present?
      @campaign.has_target=true
      @campaign.targets << Target.find(params[:target_id])   
    end
    @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    @campaign.name="Spend based Campaign"
    respond_to do |format|
       if @campaign.save    
        format.html { redirect_to(business_spend_campaign_path(@business,@campaign), :notice => 'Offer was successfully created.')}
      else
        format.html { render :action => "new" }
      end     
      format.html{ redirect_to(business_spend_campaign_path(@business,@campaign), :notice => 'Offer was successfully created.')}
    end
  rescue
    respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
    end
  end
  
  def show
    @campaign = Campaign.find(params[:id])
    @engagements=@campaign.engagements
    @rewards=@campaign.rewards
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @campaign   = Campaign.find(params[:id])
    @engagement = @campaign.engagements.first
    @rewards    = @campaign.rewards
  end
  
  def update
    @campaign = Campaign.find(params[:id])
    @campaign.places_list = params[:campaign][:places_list] unless params[:campaign][:places_list].blank?
    currency_symbol=@business.currency_symbol
    if params[:campaign][:start_date]=="" || (params[:campaign][:start_date]=="" and params[:launch_today]=="1")
      params[:campaign][:start_date]=Date.today.to_s
    end 
    reward_attrs=params[:campaign][:rewards_attributes]
    if params[:target_id].present?
      @campaign.has_target=true
      unless @campaign.targets.empty?
        @campaign.targets.update_all(:target_id=>params[:target_id])
      else
        @campaign.targets << Target.find(params[:target_id])
      end
    else    
      @campaign.targets.delete_all
      @campaign.has_target=false
    end
    engagement_attrs=params[:campaign][:engagements_attributes]["0"]
    reward_attrs=params[:campaign][:rewards_attributes]    
    if reward_attrs["0"]["expiry_date"].present? and  reward_attrs["0"]["expiry_date"].split("/").any?
      date_details1=reward_attrs["0"]["expiry_date"].split("/").reverse
      expiry_date="#{date_details1[0]}-#{date_details1[2]}-#{date_details1[1]}"
    end
    if engagement_attrs["end_date"].present? and engagement_attrs["end_date"].split("/").any?
      date_details=engagement_attrs["end_date"].split("/").reverse
      end_date="#{date_details[0]}-#{date_details[2]}-#{date_details[1]}"
    end
    params[:campaign][:engagements_attributes]["0"]["end_date"]=end_date if end_date.present?
    @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    @campaign.end_date=expiry_date if expiry_date.present?
    reward_attrs.each do |key,value|
      description="Spend #{value["needed_amount"]}#{currency_symbol}"
      description << " before #{end_date}" if end_date.present?
      description << ", Get a #{ "%0.2f" % value["money_amount"]}#{currency_symbol} Cash back"
      description << ", Offer available until #{expiry_date}" if expiry_date.present?
      params[:campaign][:rewards_attributes][key]["heading2"]=description
      params[:campaign][:rewards_attributes][key]["needed_amount"]=value["needed_amount"].to_f * engagement_attrs[:amount].to_f
      params[:campaign][:rewards_attributes][key]["name"]="#{value[:money_amount]}#{currency_symbol} Cash back"
      params[:campaign][:rewards_attributes][key]["expiry_date"]=expiry_date if expiry_date.present?
    end     
    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to(business_spend_campaign_path(@business,@campaign), :notice => 'Campaign was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  rescue
    respond_to do |format|
      format.html { render :action => "edit" }
      format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
    end
  end
  
  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to(business_campaigns_url(@business)) }
    end
  end

  private 
  def prepare_business
    @business = Business.find(params[:business_id])
  end
end
