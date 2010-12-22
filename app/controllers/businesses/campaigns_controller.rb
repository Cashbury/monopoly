class Businesses::CampaignsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :find_business
  
  def index
    @campaigns = Campaign.where(:business_id=>params[:business_id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @campaigns }
      format.json { render :text => @campaigns.to_json }
    end
  end
  
  def show
    @campaign = Campaign.find(params[:id])
  end
  
  def new
    @campaign = Campaign.new
    debugger
    @places = @business.places
  end
  
  def create
    @campaign = Campaign.new(params[:campaign])
    @campaign.business_id = params[:business_id]
    if @campaign.save
      flash[:notice] = "Successfully created campaign."
      redirect_to business_campaign_url(@business, @campaign)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @campaign = Campaign.find(params[:id])
    @places = @business.places
  end
  
  def update
    @campaign = Campaign.find(params[:id])
    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "Successfully updated campaign."
      redirect_to business_campaign_url(@business, @campaign)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    flash[:notice] = "Successfully destroyed campaign."
    redirect_to business_campaigns_url(@business)
  end
  
  private
  def find_business
    @business = Business.find(params[:business_id])
  end
end
