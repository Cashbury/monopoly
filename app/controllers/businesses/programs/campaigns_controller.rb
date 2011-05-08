class Businesses::Programs::CampaignsController < ApplicationController
	before_filter :authenticate_user!,:require_admin, :except => [:index, :show]
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
    if params[:measurement_name].present?
      @measurement_type = add_new_measurement_type 
      @campaign.measurement_type = @measurement_type
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
  
  def add_new_measurement_type
    @measurement_type = MeasurementType.new
    @measurement_type.name = params[:measurement_name]
    @measurement_type.business_id = params[:business_id]
    if @measurement_type.save
      return @measurement_type
    else
      return nil
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