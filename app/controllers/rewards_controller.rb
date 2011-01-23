class RewardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :find_business, :only => [:index]
  # before_filter :find_engagement, :only => [:index]
  before_filter :places_under_business

  #layout "application"

  def index
    @rewards = @business.rewards
    respond_to do |format|
      format.html
      format.xml { render :xml => @rewards }
      format.json { render :text => @rewards.to_json }
    end
  end
  
  def show
    @reward = Reward.find(params[:id])
  end
  
  def new
    @reward = Reward.new
  end
  
  def create
    @reward = Reward.new(params[:reward])
    @reward.campaign_id = params[:campaign_id]
    if @reward.save
      flash[:notice] = "Successfully created reward."
      redirect_to business_campaign_reward_url(@business, @campaign, @reward)
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
      redirect_to business_campaign_reward_url(@business, @campaign, @reward)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    flash[:notice] = "Successfully destroyed reward."
    redirect_to business_campaign_rewards_url(@business, @campaign)
  end
  
  private
  def find_business
    @business = Business.find(params[:business_id])
  end
  
  def find_engagement
    @engagement = Engagement.find(params[:engagement_id])
  end

  def places_under_business
    @places ||= Place.where(:business_id => params[:business_id]) 
  end
end
