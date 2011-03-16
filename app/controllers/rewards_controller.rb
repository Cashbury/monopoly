class RewardsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
    @rewards = Reward.all
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
    if @reward.save
      flash[:notice] = "Successfully created reward."
      redirect_to reward_url(@reward)
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
      redirect_to reward_url(@reward)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    flash[:notice] = "Successfully destroyed reward."
    redirect_to rewards_url
  end
end
