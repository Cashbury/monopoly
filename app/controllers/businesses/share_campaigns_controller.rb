class Businesses::ShareCampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_business#, :except=>[:select_partial]

  def new
    found=@business.programs.joins(:campaigns).where("campaigns.ctype=#{Campaign::CTYPE[:spend]}").select("campaigns.id").first
    @campaign=found.nil? ? Campaign.new : Campaign.find(found.id)
  end

  def create
    @program_type=ProgramType.find_or_create_by_name(:name=>"Marketing")
    @program     =Program.find_or_create_by_business_id_and_program_type_id(:business_id=>@business.id,:program_type_id=>@program_type.id)

    @reward_attrs=params[:campaign][:rewards_attributes]
    @reward_attrs.each do |key,value|
      params[:campaign][:rewards_attributes][key]["heading2"]="Spend $#{value["needed_amount"]} before #{params[:engagement]["0"][:end_date]}, Get a $#{value["money_amount"]} Cash back, Offer available until #{value["expiry_date"]}"
      params[:campaign][:rewards_attributes][key]["needed_amount"]=value["needed_amount"].to_f * params[:engagement]["0"][:amount].to_f if value["needed_amount"].present?
      params[:campaign][:rewards_attributes][key]["name"]="$#{value[:money_amount]} Cash back"
    end
    found=@business.programs.joins(:campaigns).where("campaigns.ctype=#{Campaign::CTYPE[:share]}").select("campaigns.id").first
    @campaign=found.nil? ? @program.campaigns.build(params[:campaign]) : Campaign.find(found.id)
    @campaign.ctype=Campaign::CTYPE[:share]

    if @campaign.engagements.empty?
      @engagement=@campaign.engagements.build(params[:engagement]["0"])
      @engagement.name="Spend Engagement"
      #@engagement.end_date=params[:engagement]["0"]["end_date"].to_date
      #@engagement.start_date = Date.today
      engagement_type_id = EngagementType::ENG_TYPE[ params[:engagement_type].to_sym ]
      @engagement.engagement_type_id=EngagementType.find_by_eng_type(engagement_type_id).id #:nodoc this is weird??
    else
      @engagement=@campaign.engagements.first
      @engagement.update_attributes(params[:engagement]["0"])
    end
    if params[:target_id].present?
      @campaign.has_target=true
      @campaign.targets << Target.find(params[:target_id])
    end
    @campaign.measurement_type= MeasurementType.find_or_create_by_name(:name=>"Points")
    @campaign.name="Share based Campaign"
    @campaign.ctype=Campaign::CTYPE[:share]
    @campaign.start_date= Date.today

    respond_to do |format|
      Campaign.transaction do
        @campaign.new_record? ? @campaign.save! : @campaign.update_attributes!(params[:campaign])
        @engagement.save if @engagement.present?
      end
      format.html{ redirect_to(business_share_campaign_path(@business,@campaign), :notice => 'Offer was successfully created.')}
    end
  #rescue
  #  respond_to do |format|
  #    format.html { render :action => "new" }
  #    format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
  #  end
  end

  private
  def prepare_business
    @business = Business.find(params[:business_id])
  end
end
