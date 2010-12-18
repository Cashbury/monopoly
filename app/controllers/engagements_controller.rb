require 'uri'

class EngagementsController < ApplicationController
  before_filter :authenticate_user!, :except => :display
  before_filter :find_business_and_campaign, :except => :display
  
  def index
    @engagements = Engagement.all
  end
  
  def show
    @engagement = Engagement.find(params[:id])
    places = Place.where(:business_id =>params[:business_id])
    unless places.blank?
      code = "http://kazdoor.heroku.com?place_id=#{places.first.id}&engagement_id=#{@engagement.id}&points=#{@engagement.points}"
      @code = URI.escape(code,Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end
  
  def new
    @engagement = Engagement.new
    @engagement.campaign_id = params[:campaign_id]
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
    @places = Place.where(:business_id => params[:business_id]) 
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

  def display
    @engagement = Engagement.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml
      format.json
    end
  end
  
  # => Author: Rajib Ahmed
  def get_qrcode
    engagement = Engagement.find(params[:id])
    place = Place.where(:business_id =>params[:business_id]).limit(1)
    code = "http://kazdoor.heroku.com?place_id=#{place.first.id}&engagement_id=#{engagement.id}&points=#{engagement.points}"
    @code = URI.escape(code,Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
    
  private
  def find_business_and_campaign
    @business = Business.find(params[:business_id])
    @campaign = Campaign.find(params[:campaign_id])
  end
end
