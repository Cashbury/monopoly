require 'uri'

class EngagementsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :display]
  
  def index
    @engagements = Engagement.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @engagements }
      format.json { render :text => @engagements.to_json}
    end
  end
  
  def show
    @engagement = Engagement.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml => @engagement }
      format.json { render :text => @engagement.to_json}
    end
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
      format.xml { render :xml => @engagement }
      format.json { render :text => @engagement.to_json}
    end
  end
  
  # => Author: Rajib Ahmed
  def stamps
    @engagements = Campaign.find(params[:campaign_id]).engagements.where(:engagement_type=>QrCode::STAMP)
    respond_to do |format|
      format.js
    end
  end
  
  def change_status
		@engagement = Engagement.find(params[:id])
		if @engagement.state == Engagement::STOPPED
			@engagement.start!
		elsif @engagement.state == Engagement::STARTED
			@engagement.stop!
		end
		render :nothing => true, :status => :ok
	end
	  
  private
  def find_business
    @business = Business.find(params[:business_id])
  end

  def places_under_business
    @places ||= Place.where(:business_id => params[:business_id]) 
  end
end
