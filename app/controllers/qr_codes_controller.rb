class QrCodesController < ApplicationController
  # GET /qr_codes
  # GET /qr_codes.xml
  def index
    search = { :engagement_id => params[:engagement_id ]}
    @qr_codes = QrCode.where search
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @qr_codes }
    end
  end

  # GET /qr_codes/1
  # GET /qr_codes/1.xml
  def show
    @qr_code = QrCode.where(:hash_code =>params[:id]).first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @qr_code }
    end
  end

  # GET /qr_codes/new
  # GET /qr_codes/new.xml
  def new
    @qr_code = QrCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @qr_code }
    end
  end

  # GET /qr_codes/1/edit
  def edit
    @qr_code = QrCode.find(params[:id])
  end

  # POST /qr_codes
  # POST /qr_codes.xml
  def create
    @qr_code = QrCode.new(params[:qr_code])

    respond_to do |format|
      if @qr_code.save
        format.html { redirect_to(@qr_code, :notice => 'Qr code was successfully created.') }
        format.xml  { render :xml => @qr_code, :status => :created, :location => @qr_code }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @qr_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /qr_codes/1
  # PUT /qr_codes/1.xml
  def update
    @qr_code = QrCode.find(params[:id])

    respond_to do |format|
      if @qr_code.update_attributes(params[:qr_code])
        format.html { redirect_to(@qr_code, :notice => 'Qr code was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @qr_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /qr_codes/1
  # DELETE /qr_codes/1.xml
  def destroy
    @qr_code = QrCode.find(params[:id])
    @qr_code.destroy

    respond_to do |format|
      format.html { redirect_to(qr_codes_url) }
      format.xml  { head :ok }
    end
  end

  
  def panel
    if request.post?
      quantity =  params[:quantity]
      engagement = Engagement.find(params[:engagement_id])

      quantity.to_i.times{
        engagement.qr_codes << QrCode.new(:code_type=>params[:code_type].to_i,:status=>params[:status].to_i)
      }
      engagement.save!
      redirect_to :action=>:index , :engagement_id=>params[:engagement_id]
    end
    @brands = Brand.where(:user_id => current_user.id)  
  end

  def update_businesses
    @businesses = Business.where(:brand_id=> params[:id]) 
    
    respond_to do |format|
      format.js 
    end
    
  end

  def update_engagements
    @engagements = Engagement.where(:business_id=> params[:id])   
    respond_to do |format|
      format.js 
    end
  end

  def scanner
    #QrCode already has a scan method
    #which depending on the type 
    #sets the status to active / inactive
    respond_to do |wants|
      wants.html {  }
    end
  end
end
