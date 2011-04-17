require 'uri'
require 'open-uri'

class Businesses::Programs::EngagementsController < ApplicationController
  before_filter :authenticate_user!,:require_admin, :except => [:index, :show, :stamps]
  before_filter :find_business_and_program_and_places
  
  before_filter :except => :display
  
  def index
    @engagements = @program.engagements
    respond_to do |format|
      format.html
      format.xml { render :xml => @engagements }
      format.json { render :text => @engagements.to_json}
    end
  end
  
  def show
    @engagement = @program.engagements.find(params[:id])
    
    respond_to do |format|
      format.pdf do
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
    @engagement = @program.engagements.new(params[:engagement])
    if @engagement.save
      flash[:notice] = "Successfully created engagement."
      redirect_to business_program_engagement_url(@program, @program, @engagement)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @engagement = Engagement.find(params[:id])
  end
  
  def update
    @engagement = Engagement.find(params[:id])
    
    if @engagement.update_attributes(params[:engagement])
      flash[:notice] = "Successfully updated engagement."
      redirect_to business_program_engagement_url(@business, @program, @engagement)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @engagement = Engagement.find(params[:id])
    @engagement.destroy
    flash[:notice] = "Successfully destroyed engagement."
    redirect_to business_program_engagements_url(@program)
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
    @engagements = Engagement.where(:program_id=>params[:program_id] , :engagement_type => QrCode::STAMP)    
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
  def find_business_and_program_and_places
    @program = Program.find(params[:program_id])
    @business = @program.business
    @places = @business.places
    
  end
  
  def save_image(url)
     open("#{RAILS_ROOT}/public/images/qrcodes/image.png","wb")  do |io|
       io << open(URI.parse(url)).read
     end
  end
  
end