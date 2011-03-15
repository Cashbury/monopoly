class Businesses::Programs::RewardsController < ApplicationController
  before_filter :authenticate_user!,:require_admin, :except => [:index]
  before_filter :find_business_and_program
  before_filter :places_under_business

  def index
    @rewards = @program.rewards
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
    @reward = @program.rewards.new(params[:reward])
    if @reward.save
      flash[:notice] = "Successfully created reward."
      redirect_to business_program_reward_url(@business,@program,@reward)
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
      redirect_to business_program_reward_url(@business, @program, @reward)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    flash[:notice] = "Successfully destroyed reward."
    redirect_to business_program_rewards_url(@business, @program)
  end
  
  private
  def find_business_and_program
    @program     = Program.find(params[:program_id])
    @business    = @program.business
    @engagements = @program.engagements.stamps
  end

  def places_under_business
    @places ||= Place.where(:business_id => params[:business_id]) 
  end
end
