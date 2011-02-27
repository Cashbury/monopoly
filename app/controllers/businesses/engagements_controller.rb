require 'uri'
require 'open-uri'

class Businesses::EngagementsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :stamps]
  before_filter :find_business_and_places
  
  before_filter :except => :display
  
  def index
    @engagements = @business.engagements
    respond_to do |format|
      format.html
      format.xml { render :xml => @engagements }
      format.json { render :text => @engagements.to_json}
    end
  end
  
  def show
    @engagement = @business.engagements.find(params[:id])
    
    respond_to do |format|
      format.pdf do
        for place in @engagement.places do
           url = Engagement.qrcode(place.id,@engagement.id, @engagement.points , @engagement.created_at ,place.created_at)
           save_image(url)
        end
        render  :pdf => "#{@business.name}_qrcode"
      end
      format.html
      format.xml { render :xml => @engagement }
      format.json { render :text => @engagement.to_json}
    end
  end

  
  def new
    @engagement = Engagement.new
  end
  
  def create
    @engagement = @business.engagements.new(params[:engagement])
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
    @engagements = @business.engagements.where(:engagement_type=>"stamp")
    respond_to do |format|
      format.html
      format.xml { render :xml => @engagements }
      format.json { render :text => @engagements.to_json}
    end
  end

  
  def issue_code
    @qrcode = QrCode.where( :place_id => params[:id], :engagement_id=>params[:engagement_id] ).first
    if @qrcode.blank? 
        @qrcode = QrCode.create( :place_id=>params[:id] , :engagement_id=> params[:engagement_id]).save!
    else 
      @qrcode.save
    end

    respond_to do |format|
      format.html
      format.js
    end    
  end
    

  private
  def find_business_and_places
    @business = Business.find(params[:business_id])
    @places = @business.places
  end
  
  def save_image(url)
     open("#{RAILS_ROOT}/public/images/qrcodes/image.png","wb")  do |io|
       io << open(URI.parse(url)).read
     end
  end
  
end
