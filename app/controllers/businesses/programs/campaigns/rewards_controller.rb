class Businesses::Programs::Campaigns::RewardsController < ApplicationController
  before_filter :authenticate_user!,:require_admin, :except => [:index]
  before_filter :find_business_and_program_and_campaign
  before_filter :places_under_business , :items_uder_business

  def index
    @rewards = @campaign.rewards
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
    @reward = @campaign.rewards.new(params[:reward])
    if @reward.save
      flash[:notice] = "Successfully created reward."
      redirect_to business_program_campaign_reward_url(@business,@program,@campaign,@reward)
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
      redirect_to business_program_campaign_reward_url(@business, @program, @campaign,@reward)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    flash[:notice] = "Successfully destroyed reward."
    redirect_to business_program_campaign_rewards_url(@business, @program, @campaign)
  end
  
  private
  def find_business_and_program_and_campaign
    @program     = Program.find(params[:program_id])
    @business    = @program.business
    @campaign    = Campaign.find(params[:campaign_id]) 
    @engagements = @campaign.engagements.stamps #TODO check this will be sub with what ? 
  end

  def places_under_business
    @places ||= Place.where(:business_id => params[:business_id]) 
  end
  def items_uder_business
    @items = Item.where(:business_id => params[:business_id])
  end
end
