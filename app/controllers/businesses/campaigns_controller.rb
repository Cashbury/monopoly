class Businesses::CampaignsController < ApplicationController
  before_filter :prepare_business
  
  def index
    program_type=ProgramType.find_or_create_by_name(:name=>"Marketing")
    program=Program.where(:business_id=>@business.id,:program_type_id=>program_type.id).first
    @campaigns=program.nil? ? [] : program.campaigns
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @campaign=Campaign.new
    @campaign.engagements.build
    @reward=@campaign.rewards.build
    @reward.build_reward_image
  end

  def create
    @program_type=ProgramType.find_or_create_by_name(:name=>"Marketing")
    @program     =Program.find_or_create_by_business_id_and_program_type_id(:business_id=>@business.id,:program_type_id=>@program_type.id)
    eng_attrs    =params[:campaign][:engagements_attributes]["0"]
    reward_attrs =params[:campaign][:rewards_attributes]["0"]
    params[:campaign][:engagements_attributes]["0"]["name"]="#{eng_attrs[:item_id]!="" ? 'Buy' : EngagementType.find(eng_attrs[:engagement_type_id]).try(:name)} #{eng_attrs[:item_id]=="" ? '' : Item.find(eng_attrs[:item_id]).try(:name)} #{reward_attrs[:needed_amount]} times, Get a free #{reward_attrs[:name]}"
    params[:campaign][:start_date]=Date.today if params[:launch_today]=="1"
    @campaign    =@program.campaigns.build(params[:campaign])
    if params[:target_id].present?
      @campaign.has_target=true
      @campaign.targets << Target.find(params[:target_id])   
    end
    eng_type =EngagementType.find(eng_attrs[:engagement_type_id])
    if eng_type.has_item?
      item=Item.find(eng_attrs[:item_id]) unless eng_attrs[:item_id].blank?
      item_name=item.nil? ? "item points": item.name
      @campaign.measurement_type=MeasurementType.find_or_create_by_name_and_business_id(:name=>"#{item_name.capitalize} points",:business_id=>@business.id)
    elsif eng_type.is_visit?
      @campaign.measurement_type=MeasurementType.find_or_create_by_name_and_business_id(:name=>"Visit points",:business_id=>@business.id)
    else
      @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    end
    @campaign.name="#{reward_attrs[:name].capitalize} Campaign"
    respond_to do |format|
      if @campaign.save    
        format.html { redirect_to(business_campaign_path(@business,@campaign), :notice => 'Campaign was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end
  def show
    @campaign = Campaign.find(params[:id])
    @engagement=@campaign.engagements.first
    @reward=@campaign.rewards.first
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @campaign = Campaign.find(params[:id])
    @engagement=@campaign.engagements.first
    @reward=@campaign.rewards.first
    @reward.build_reward_image unless @reward.reward_image.present?
  end
  
  def update
    @campaign             = Campaign.find(params[:id])
    @campaign.places_list = params[:campaign][:places_list] unless params[:campaign][:places_list].blank?
    params[:campaign][:start_date]=Date.today if params[:launch_today]=="1"
    eng_attrs   =params[:campaign][:engagements_attributes]["0"]
    reward_attrs=params[:campaign][:rewards_attributes]["0"]
    @campaign.name="#{reward_attrs[:name].capitalize} Campaign"
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
    eng_type=EngagementType.find(eng_attrs[:engagement_type_id])
    if eng_type.has_item?
      item=Item.find(eng_attrs[:item_id]) unless eng_attrs[:item_id].blank?
      item_name=item.nil? ? "item points": item.name
      @campaign.measurement_type=MeasurementType.find_or_create_by_name(:name=>"#{item_name.capitalize} points",:business_id=>@business.id)
    elsif eng_type.is_visit?
      @campaign.measurement_type=MeasurementType.find_or_create_by_name(:name=>"visit points",:business_id=>@business.id)
    else
      @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    end
    params[:campaign][:engagements_attributes]["0"]["name"]="#{eng_attrs[:item_id]!="" ? 'Buy' : EngagementType.find(eng_attrs[:engagement_type_id]).try(:name)} #{eng_attrs[:item_id]=="" ? '' : Item.find(eng_attrs[:item_id]).try(:name)} #{reward_attrs[:needed_amount]} times, Get a free #{reward_attrs[:name]}"
    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to(business_campaign_path(@business,@campaign), :notice => 'Campaign was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
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
