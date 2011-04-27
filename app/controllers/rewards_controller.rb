class RewardsController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_brands

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
    @reward.campaign_id = params[:campaign_id]
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
  
  def update_businesses
    @businesses = Business.where(:brand_id=> params[:id])
    respond_to do |format|
      format.js 
    end
    
  end
  
  def update_programs
    @programs = Program.where(:business_id=> params[:id]) 

    respond_to do |format|
      format.js 
    end
    
  end
  
   def update_campaigns
    @campaigns= Campaign.where(:program_id=> params[:id]) 

    respond_to do |format|
      format.js 
    end
    
  end
  private 
  def prepare_brands
    @brands = Brand.all
  end
end
