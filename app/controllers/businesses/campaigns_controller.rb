class Businesses::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_business#, :except=>[:select_partial]
  
  def index
    program_type=ProgramType.find_or_create_by_name("Marketing")
    program=Program.where(:business_id=>@business.id,:program_type_id=>program_type.id).first
    @campaigns=program.nil? ? [] : program.campaigns.select {|c| c.ctype==Campaign::CTYPE[:spend] || (c.engagements.size==1 && c.rewards.size==1)}
    
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
    params[:campaign][:engagements_attributes]["0"]["name"]="#{params[:item_name]!="" ? 'Buy' : EngagementType.find(eng_attrs[:engagement_type_id]).try(:name)} #{params[:item_name]}"
    params[:campaign][:engagements_attributes]["0"]["description"]="#{params[:item_name]!="" ? 'Buy' : EngagementType.find(eng_attrs[:engagement_type_id]).try(:name)} #{params[:item_name]} #{reward_attrs[:needed_amount]} times, Get a free #{reward_attrs[:name]}"
    if params[:campaign][:start_date]=="" || (params[:campaign][:start_date]=="" and params[:launch_today]=="1")
      params[:campaign][:start_date]=Date.today.to_s
    end 
    @campaign    =@program.campaigns.build(params[:campaign])
    if params[:target_id].present?
      @campaign.has_target=true
      @campaign.targets << Target.find(params[:target_id])   
    end
    eng_type =EngagementType.find(eng_attrs[:engagement_type_id])
    if eng_type.eng_type==EngagementType::ENG_TYPE[:buy] 
      @campaign.measurement_type=MeasurementType.find_or_create_by_name_and_business_id(:name=>"#{params[:item_name].try(:capitalize)} points",:business_id=>@business.id)
    elsif eng_type.eng_type==EngagementType::ENG_TYPE[:visit]
      @campaign.measurement_type=MeasurementType.find_or_create_by_name_and_business_id(:name=>"Visit points",:business_id=>@business.id)
    else
      @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    end
    @campaign.name="#{reward_attrs[:name].capitalize} Campaign"
    respond_to do |format|
      if @campaign.save!    
        format.html { 
          @reward=@campaign.rewards.first
          if reward_attrs[:reward_image_attributes].blank? || !@reward.reward_image.need_cropping
            redirect_to(business_campaign_path(@business,@campaign), :notice => 'Campaign was successfully created.') 
          else
            render :action => 'crop'  
          end
        }
      else
        @campaign.errors.add(:item_name,"can't be blank") if params[:item_name]==""
        @reward=@campaign.rewards.first
        @reward.build_reward_image unless @reward.reward_image.present?
        format.html { render :action => "new" }
      end
    end
  rescue
    respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
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
    @campaign  = Campaign.find(params[:id])
    @engagement=@campaign.engagements.first
    @reward    =@campaign.rewards.first
    @reward.build_reward_image unless @reward.reward_image.present?
    @item_name =@engagement.name.gsub(/Buy\s+/,'') 
  end
  
  def update
    @campaign = Campaign.find(params[:id])
    @campaign.places_list = params[:campaign][:places_list] unless params[:campaign][:places_list].blank?
    if params[:campaign][:start_date]=="" || (params[:campaign][:start_date]=="" and params[:launch_today]=="1")
      params[:campaign][:start_date]=Date.today.to_s
    end 
    eng_attrs=params[:campaign][:engagements_attributes]["0"]
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
    if eng_type.eng_type==EngagementType::ENG_TYPE[:buy]
      @campaign.measurement_type=MeasurementType.find_or_create_by_name_and_business_id(:name=>"#{params[:item_name].capitalize} points",:business_id=>@business.id)
  elsif eng_type.eng_type==EngagementType::ENG_TYPE[:visit]
      @campaign.measurement_type=MeasurementType.find_or_create_by_name_and_business_id(:name=>"Visit points",:business_id=>@business.id)
    else
      @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    end
    params[:campaign][:engagements_attributes]["0"]["name"]="#{params[:item_name]!="" ? 'Buy' : EngagementType.find(eng_attrs[:engagement_type_id]).try(:name)} #{params[:item_name]}"
    params[:campaign][:engagements_attributes]["0"]["description"]="#{params[:item_name]!="" ? 'Buy' : EngagementType.find(eng_attrs[:engagement_type_id]).try(:name)} #{params[:item_name]} #{reward_attrs[:needed_amount]} times, Get a free #{reward_attrs[:name]}"
    respond_to do |format|
      if @campaign.update_attributes!(params[:campaign])
        format.html {
          @reward=@campaign.rewards.first
          if reward_attrs[:reward_image_attributes].blank? || !@reward.reward_image.needed_cropping?
            redirect_to(business_campaign_path(@business,@campaign), :notice => 'Campaign was successfully updated.') 
          else
            render :action => 'crop'  
          end
        }
      else
        @campaign.errors.add(:item_name,"can't be blank") if params[:item_name]==""
        @reward=@campaign.rewards.first
        @reward.build_reward_image unless @reward.reward_image.present?
        @item_name =@campaign.engagements.first.name.gsub(/Buy\s+/,'')
        format.html { render :action => "edit" }
      end
    end
  rescue
    respond_to do |format|
      format.html { render :action => "edit" }
      format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
    end
  end
  def crop_image
    @campaign=Campaign.find(params[:campaign_id])
    @reward=Reward.find(params[:reward_id])
    if @reward.update_attributes!(params[:reward])
      redirect_to(business_campaign_path(@business,@campaign), :notice => 'Campaign was successfully updated.') 
    else    
      render :action=>"crop"
    end    
  end
  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to(business_campaigns_url(@business)) }
    end
  end
  
  #def select_partial
  #  engagement_type=EngagementType.find(params[:eng_type])
  #  if engagement_type.eng_type==EngagementType::ENG_TYPE[:buy]
  #    render :partial=>"buy_formula"
  #  elsif engagement_type.eng_type==EngagementType::ENG_TYPE[:visit]
  #    render :partial=>"visit_formula"
  #  else
  #    render :partial=>"spend_formula"
  #  end
  #end
  
  private 
  def prepare_business
    @business = Business.find(params[:business_id])
  end
end
