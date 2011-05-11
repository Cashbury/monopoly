require 'uri'
require 'open-uri'

class Businesses::Programs::Campaigns::EngagementsController < ApplicationController
  before_filter :authenticate_user!,:require_admin, :except => [:index, :show, :stamps]
  before_filter :find_business_and_program_and_and_campaign
  
  before_filter :except => :display
  
  def index
    @engagements = @campaign.engagements
    respond_to do |format|
      format.html
      format.xml { render :xml => @engagements }
      format.json { render :text => @engagements.to_json}
    end
  end
  
  def show
    @engagement = @campaign.engagements.find(params[:id])
    
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
    @items= @engagement.items_list(@campaign)
  end
  
  def create
    @engagement = @campaign.engagements.new(params[:engagement])
    @engagement.amount=1 if @campaign.measurement_type.business
    if @engagement.save
      flash[:notice] = "Successfully created engagement."
      redirect_to business_program_campaign_engagement_url(@business, @program,@campaign ,@engagement)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @engagement = Engagement.find(params[:id])
    @items= @engagement.items_list
  end
  
  def update
    @engagement = Engagement.find(params[:id])
    @engagement.amount=1 if @campaign.measurement_type.business
    if @engagement.update_attributes(params[:engagement])
      flash[:notice] = "Successfully updated engagement."
      redirect_to business_program_campaign_engagement_url(@business, @program, @campaign,@engagement)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @engagement = Engagement.find(params[:id])
    @engagement.destroy
    flash[:notice] = "Successfully destroyed engagement."
    redirect_to business_program_campaign_engagements_url(@business,@program,@campaign)
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
    @engagements = Engagement.where(:campaign_id=>params[:campaign_id] , :engagement_type => QrCode::STAMP)    
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
  def find_business_and_program_and_and_campaign
    @program = Program.find(params[:program_id])
    @business = @program.business
    @campaign = Campaign.find(params[:campaign_id])
    @engagement_types = EngagementType.order("name ASC")
    @items=[]
  end
  
  def save_image(url)
     open("#{RAILS_ROOT}/public/images/qrcodes/image.png","wb")  do |io|
       io << open(URI.parse(url)).read
     end
  end
  
end