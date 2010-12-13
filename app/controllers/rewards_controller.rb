class RewardsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_business_and_campaign_and_engagment
  def index
    @rewards = Reward.all
  end
  
  def show
    @reward = Reward.find(params[:id])
  end
  
  def new
    @reward = Reward.new
  end
  
  def create
    @reward = Reward.new(params[:reward])
    if @reward.save
      flash[:notice] = "Successfully created reward."
      redirect_to business_campaign_engagement_reward_url(@business, @campaign, @engagement, @reward)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @reward = Reward.find(params[:id])
  end
  
  def update
    @reward = Reward.find(params[:id])
    if @reward.update_attributes(params[:reward])
      flash[:notice] = "Successfully updated reward."
      redirect_to business_campaign_engagement_reward_url(@business, @campaign, @engagement, @reward)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    flash[:notice] = "Successfully destroyed reward."
    redirect_to business_campaign_engagement_rewards_url(@business, @campaign, @engagement)
  end
  
  private
  def find_business_and_campaign_and_engagment
    @business = Business.find(params[:business_id])
    @campaign = Campaign.find(params[:campaign_id])
    @engagement = Engagement.find(params[:engagement_id])
  end
end