require 'uri'

class EngagementsController < ApplicationController
  before_filter :authenticate_user!,
                :find_business, 
                :places_under_business,
                :except => :display
  
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
      redirect_to business_engagement_url(@business, @engagement)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @engagement = Engagement.find(params[:id])
  end
  
  def update
    #debugger
    @engagement = Engagement.find(params[:id])
    
    if @engagement.update_attributes(params[:engagement])
      flash[:notice] = "Successfully updated engagement."
      redirect_to business_engagement_url(@business, @engagement)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @engagement = Engagement.find(params[:id])
    @engagement.destroy
    flash[:notice] = "Successfully destroyed engagement."
    redirect_to business_engagements_url(@business)
  end

  def display
    @engagement = Engagement.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml
      format.json
    end
  end
  
  # => Author: Rajib Ahmed
  def stamps
    @engagements = Campaign.find(params[:campaign_id]).engagements.where(:engagement_type=>"stamp")
    respond_to do |format|
      format.js
    end
  end
    
  private
  def find_business
    @business = Business.find(params[:business_id])
  end

  def places_under_business
    @places ||= Place.where(:business_id => params[:business_id]) 
  end
end
