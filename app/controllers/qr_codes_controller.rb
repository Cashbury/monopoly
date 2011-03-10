class QrCodesController < ApplicationController
  # GET /qr_codes
  # GET /qr_codes.xml
  def index
    @qr_codes = search_qrs 
    @templates = Template.where(:user_id =>current_user.id)

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
      format.pdf do
        render  :pdf => "qrcode"
      end
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
    engagement_id = @qr_code.engagement_id
    @qr_code.destroy
    respond_to do |format|
      format.html { redirect_to :action=>:index , :engagement_id =>engagement_id }
      format.xml  { head :ok }
    end
  end

  
  def panel
    if request.post?
      quantity =  params[:quantity].to_i
      engagement = Engagement.where(:id=> params[:engagement_id]).first
     
      if engagement.blank?
        redirect_to :action =>:panel ,:notice => "No egagement exists"
      else
        #when everything is ok
        quantity.times{
          engagement.qr_codes << QrCode.new(:code_type=>params[:code_type].to_i,:status=>params[:status].to_i)
        }
        if engagement.save
          redirect_to :action=>:index , :engagement_id=>params[:engagement_id]
        else
          render :action => :panel
        end
      end

    end

    @brands = Brand.where(:user_id => current_user.id)  
  end

  def printable
    if request.post?
      @qrcodes = search_qrs
      @template = Template.find(params[:template_id])

      respond_to do |format|
        format.pdf do
        render  :pdf => "qrcode"
      end   
     end
    else
      redirect_to nil
    end
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

  def search_qrs
    search = {:engagement_id =>params[:engagement_id]}
    search = search.merge({:status=>params[:status]}) unless params[:status].blank?
    search = search.merge({:code_type=>params[:code_type]}) unless params[:code_type].blank?
    QrCode.where search
  end

end
