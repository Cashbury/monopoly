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
    @campaign=Campaign.new
    @campaign.engagements.build
    @campaign.rewards.build
  end

  def create
    @program_type=ProgramType.find_or_create_by_name(:name=>"Marketing")
    @program =Program.find_or_create_by_business_id_and_program_type_id(:business_id=>@business.id,:program_type_id=>@program_type.id)
    campaign_params=prepare_spend_campaign_params(params[:campaign])
    @campaign=@program.campaigns.build(campaign_params)
    @campaign.ctype=Campaign::CTYPE[:spend]
    if params[:target_id].present?
      @campaign.has_target=true
      @campaign.targets << Target.find(params[:target_id])
    end
    @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    @campaign.name="Spend based Campaign"
    respond_to do |format|
       if @campaign.save
         #save_share_engagement(params[:share]) if params[:share].present?
        format.html { redirect_to(business_spend_campaign_path(@business,@campaign), :notice => 'Offer was successfully created.')}
       else
        format.html { render :action => "new" }
       end
      format.html{ redirect_to(business_spend_campaign_path(@business,@campaign), :notice => 'Offer was successfully created.')}
    end
  rescue
    respond_to do |format|
      format.html { render :action => "new" }
      format.xml { render :xml => @campaign.errors, :status => :unprocessable_entity }
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
    @campaign = Campaign.find(params[:id])
    @engagement = @campaign.engagements.first
    @rewards = @campaign.rewards
    #@share_engagement = @campaign.engagements.where(:engagement_type_id=>4).first
  end
  
  def update
    @campaign = Campaign.find(params[:id])
    @campaign.places_list = params[:campaign][:places_list] unless params[:campaign][:places_list].blank?
    @engagement = @campaign.engagements.first
    @rewards= @campaign.rewards
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
    uniq_entries={}
    params[:campaign][:rewards_attributes].each_pair{|k,v| uniq_entries[k]=v unless uniq_entries.has_value?(v)}
    params[:campaign][:rewards_attributes]=uniq_entries
    reward_attrs=params[:campaign][:rewards_attributes]
    if reward_attrs["0"]["expiry_date"].present?
      if reward_attrs["0"]["expiry_date"].match(/\//).present?
        date_details=reward_attrs["0"]["expiry_date"].split("/").reverse
        expiry_date="#{date_details[0]}-#{date_details[2]}-#{date_details[1]}"
      else
        expiry_date=reward_attrs["0"]["expiry_date"]
      end
    end
    if engagement_attrs["end_date"].present?
      if engagement_attrs["end_date"].match(/\//).present?
        date_details=engagement_attrs["end_date"].split("/").reverse
        end_date="#{date_details[0]}-#{date_details[2]}-#{date_details[1]}"
      else
        end_date=engagement_attrs["end_date"]
      end
    end
    params[:campaign][:engagements_attributes]["0"]["end_date"]=end_date if end_date.present?
    @campaign.end_date=expiry_date if expiry_date.present?
    reward_attrs.each_with_index do |(key,value),index|
      description="Spend #{currency_symbol}#{value["needed_money_amount"]}"
      description << " before #{end_date}" if end_date.present?
      money_amount= value["money_amount"].to_f.to_s.match(/\.0$/) ? value["money_amount"] : "%0.2f" % value["money_amount"]
      description << ", Get a #{currency_symbol}#{money_amount} Cash back" if money_amount.present?
      description << ", Offer available until #{expiry_date}" if expiry_date.present?
      params[:campaign][:rewards_attributes][key]["heading2"]= description
      
      if @engagement.amount.to_f != engagement_attrs[:amount].to_f || @rewards[index].nil? || @rewards[index].needed_money_amount != value["needed_money_amount"].to_f
        params[:campaign][:rewards_attributes][key]["needed_amount"]=value["needed_money_amount"].to_f * engagement_attrs[:amount].to_f
      end
      params[:campaign][:rewards_attributes][key]["name"]="#{currency_symbol}#{money_amount} Cash back"
      params[:campaign][:rewards_attributes][key]["expiry_date"]=expiry_date if expiry_date.present?
    end
    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        #save_share_engagement(params[:share]) if params[:share].present?
        format.html { redirect_to(business_spend_campaign_path(@business,@campaign), :notice => 'Campaign was successfully updated.') }
      else
        @engagement = @campaign.engagements.first
        format.html { render :action => "edit" }
      end
    end
  rescue
    respond_to do |format|
      format.html { render :action => "edit" }
      format.xml { render :xml => @campaign.errors, :status => :unprocessable_entity }
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
  
  def prepare_spend_campaign_params(campaign_params)
    currency_symbol=@business.currency_symbol
    if campaign_params[:start_date]=="" || (campaign_params[:start_date]=="" and params[:launch_today]=="1")
      campaign_params[:start_date]=Date.today.to_s
    end
    @engagement_attrs=campaign_params[:engagements_attributes]["0"]
    uniq_entries={}
    campaign_params[:rewards_attributes].each_pair{|k,v| uniq_entries[k]=v unless uniq_entries.has_value?(v)}
    campaign_params[:rewards_attributes]=uniq_entries
    @reward_attrs=campaign_params[:rewards_attributes]
    if @reward_attrs["0"]["expiry_date"].present?
      if @reward_attrs["0"]["expiry_date"].match(/\//).present?
        date_details=@reward_attrs["0"]["expiry_date"].split("/").reverse
        expiry_date="#{date_details[0]}-#{date_details[2]}-#{date_details[1]}"
      else
        expiry_date=@reward_attrs["0"]["expiry_date"]
      end
    end
    if @engagement_attrs["end_date"].present?
      if @engagement_attrs["end_date"].match(/\//).present?
        date_details=@engagement_attrs["end_date"].split("/").reverse
        end_date="#{date_details[0]}-#{date_details[2]}-#{date_details[1]}"
      else
        end_date=@engagement_attrs["end_date"]
      end
    end
    campaign_params[:end_date]=expiry_date.to_date if expiry_date.present?
    campaign_params[:engagements_attributes]["0"]["engagement_type_id"]=EngagementType.find_by_eng_type(EngagementType::ENG_TYPE[:spend]).id
    campaign_params[:engagements_attributes]["0"]["name"]="Spend Engagement"
    campaign_params[:engagements_attributes]["0"]["end_date"]=end_date if end_date.present?
    @reward_attrs.each do |key,value|
      description="Spend #{currency_symbol}#{value["needed_money_amount"]}"
      description << " before #{end_date}" if @engagement_attrs[:end_date].present?
      money_amount= value["money_amount"].to_f.to_s.match(/\.0$/) ? value["money_amount"] : "%0.2f" % value["money_amount"]
      description << ", Get a #{currency_symbol}#{money_amount} Cash back" if money_amount.present?
      description << ", Offer available until #{expiry_date}" if @reward_attrs["0"]["expiry_date"].present?
      campaign_params[:rewards_attributes][key]["heading2"]=description
      campaign_params[:rewards_attributes][key]["needed_amount"]=value["needed_money_amount"].to_f * @engagement_attrs[:amount].to_f if value["needed_money_amount"].present?
      campaign_params[:rewards_attributes][key]["name"]="#{currency_symbol}#{money_amount} Cash back"
      campaign_params[:rewards_attributes][key]["expiry_date"]=expiry_date if expiry_date.present?
    end
    campaign_params
  end
  
  def save_share_engagement(share)
    if share[:id].blank?
      share = share.delete_if {|n| n=="id"}
      @share_engagement= @campaign.engagements.create!(share)
    else
      @share_engagement = Engagement.find(share[:id])
      @share_engagement.update_attributes!(:amount=>share[:amount], :fb_engagement_msg=>share[:fb_engagement_msg])
    end
  end
end
