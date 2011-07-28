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
    found=@business.programs.joins(:campaigns).where("campaigns.ctype=#{Campaign::CTYPE[:spend]}").select("campaigns.id").first
    @campaign=found.nil? ? Campaign.new : Campaign.find(found.id)
  end

  def create
    @program_type=ProgramType.find_or_create_by_name(:name=>"Marketing")
    @program     =Program.find_or_create_by_business_id_and_program_type_id(:business_id=>@business.id,:program_type_id=>@program_type.id)
    currency_symbol=ISO4217::Currency.from_code(@business.currency_code).symbol
    if params[:campaign][:start_date]=="" || (params[:campaign][:start_date]=="" and params[:launch_today]=="1")
      params[:campaign][:start_date]=Date.today.to_s
    end 
    @reward_attrs=params[:campaign][:rewards_attributes]
    @reward_attrs.each do |key,value| 
      params[:campaign][:rewards_attributes][key]["heading2"]="Spend #{value["needed_amount"]}#{currency_symbol} before #{params[:engagement]["0"][:end_date]}, Get a #{value["money_amount"]}#{currency_symbol} Cash back, Offer available until #{value["expiry_date"]}"
      params[:campaign][:rewards_attributes][key]["needed_amount"]=value["needed_amount"].to_f * params[:engagement]["0"][:amount].to_f if value["needed_amount"].present?
      params[:campaign][:rewards_attributes][key]["name"]="$#{value[:money_amount]} Cash back"
    end
    found=@business.programs.joins(:campaigns).where("campaigns.ctype=#{Campaign::CTYPE[:spend]}").select("campaigns.id").first
    @campaign=found.nil? ? @program.campaigns.build(params[:campaign]) : Campaign.find(found.id)
    @campaign.ctype=Campaign::CTYPE[:spend]
    if @campaign.engagements.empty?
      @engagement=@campaign.engagements.build(params[:engagement]["0"])
      @engagement.name="Spend Engagement"
      @engagement.end_date=params[:engagement]["0"]["end_date"].to_date
      @engagement.engagement_type_id=EngagementType.find_by_eng_type(EngagementType::ENG_TYPE[:spend]).id      
    else  
      @engagement=@campaign.engagements.first
      @engagement.update_attributes(params[:engagement]["0"])
    end    
    if params[:target_id].present?
      @campaign.has_target=true
      @campaign.targets << Target.find(params[:target_id])   
    end
    @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    @campaign.name="Spend based Campaign"
    @campaign.ctype=Campaign::CTYPE[:spend]
    respond_to do |format|
      Campaign.transaction do
        @campaign.new_record? ? @campaign.save! : @campaign.update_attributes!(params[:campaign])
        @engagement.save if @engagement.present?
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
    currency_symbol=ISO4217::Currency.from_code(@business.currency_code).symbol
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
    @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    reward_attrs.each do |key,value| 
      params[:campaign][:rewards_attributes][key]["heading2"]="Spend #{value["needed_amount"]}#{currency_symbol} before #{params[:end_date]}, Get a #{value["money_amount"]}#{currency_symbol} Cash back, Offer available until #{value["expiry_date"]}"
      params[:campaign][:rewards_attributes][key]["campaign_id"]=@campaign.id
      params[:campaign][:rewards_attributes][key]["needed_amount"]=value["needed_amount"].to_f * params[:engagement]["0"][:amount].to_f
      params[:campaign][:rewards_attributes][key]["name"]="#{value[:money_amount]}#{currency_symbol} Cash back"
    end     
    respond_to do |format|
      if @campaign.update_attributes!(params[:campaign])
        engagement=@campaign.engagements.first
        engagement.update_attribute(:end_date,params[:end_date])
        format.html {         
          redirect_to(business_spend_campaign_path(@business,@campaign), :notice => 'Campaign was successfully updated.') 
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

  private 
  def prepare_business
    @business = Business.find(params[:business_id])
  end
end
