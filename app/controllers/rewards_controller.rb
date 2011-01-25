class RewardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :find_business_and_engagments
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
    @reward = @business.rewards.new(params[:reward])
    if @reward.save
      flash[:notice] = "Successfully created reward."
      redirect_to business_reward_url(@business, @reward)
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
      redirect_to business_reward_url(@business, @reward)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    flash[:notice] = "Successfully destroyed reward."
    redirect_to business_rewards_url(@business)
  end
  
  private
  def find_business_and_engagments
    @business = Business.find(params[:business_id])
    @engagements = @business.engagements
  end

  def places_under_business
    @places ||= Place.where(:business_id => params[:business_id]) 
  end
end
