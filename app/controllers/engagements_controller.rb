class EngagementsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_business_and_campaign
  
  def index
    @engagements = Engagement.all
  end
  
  def show
    @engagement = Engagement.find(params[:id])
  end
  
  def new
    @engagement = Engagement.new
  end
  
  def create
    @engagement = Engagement.new(params[:engagement])
    if @engagement.save
      flash[:notice] = "Successfully created engagement."
      redirect_to business_campaign_engagement_url(@business, @campaign, @engagement)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @engagement = Engagement.find(params[:id])
  end
  
  def update
    @engagement = Engagement.find(params[:id])
    if @engagement.update_attributes(params[:engagement])
      flash[:notice] = "Successfully updated engagement."
      redirect_to business_campaign_engagement_url(@business, @campaign, @engagement)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @engagement = Engagement.find(params[:id])
    @engagement.destroy
    flash[:notice] = "Successfully destroyed engagement."
    redirect_to business_campaign_engagements_url(@business, @campaign)
  end
  
  private
  def find_business_and_campaign
    @business = Business.find(params[:business_id])
    @campaign = Campaign.find(params[:campaign_id])
  end
end