class Businesses::Programs::CampaignsController < ApplicationController
	before_filter :authenticate_user!, :require_admin
	before_filter :find_business_and_program

  def index
    @program = Program.find(params[:program_id])
    @campaigns = @program.campaigns

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @campaigns }
    end
  end

  def show
    @campaign = @program.campaigns.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @campaign }
    end
  end

  def new
    @campaign = Campaign.new
    @campaign.places.build
    @campaign.engagements.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @campaign }
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
  end

  def create
    @campaign = @program.campaigns.new(params[:campaign])
    @campaign.places_list = params[:campaign][:places_list] unless params[:campaign][:places_list].blank?
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

    if params[:measurement_name].present?
      #MeasurementType.exists?(:name=>params[:measurement_name], :business_id=>params[:business_id])
      @campaign.measurement_type_id = MeasurementType.create!(:name=>params[:measurement_name], :business_id=>params[:business_id]).id
    end
    respond_to do |format|
      if @campaign.save
        format.html { redirect_to(business_program_campaign_url(@business,@program,@campaign), :notice => 'Campaign was successfully created.') }
        format.xml  { render :xml => @campaign, :status => :created, :location => @campaign }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @campaign = Campaign.find(params[:id])
    @campaign.places_list = params[:campaign][:places_list] unless params[:campaign][:places_list].blank?

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
    if params[:measurement_name].present?
      @campaign.measurement_type_id = MeasurementType.create!(:name=>params[:measurement_name], :business_id=>params[:business_id]).id
    end
    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to(business_program_campaign_url(@business, @program,@campaign), :notice => 'Campaign was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @campaign.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to(business_program_campaigns_url(@business,@program)) }
      format.xml  { head :ok }
    end
  end

  private
  def find_business_and_program
    @business = Business.find(params[:business_id])
    @program  = Program.find(params[:program_id])
    @measurement_types  = MeasurementType.where("business_id = :business_id OR business_id is null", {:business_id => @business.id})
    @temp_measurement_type = MeasurementType.new(:id=> '-1', :name => "Other")
    @measurement_types << @temp_measurement_type
  end
end
