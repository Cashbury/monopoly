class QrCodesController < ApplicationController
  before_filter :authenticate_user!, :require_admin, :except=>[:show,:check_code_status]
  before_filter :prepare_filters_data, :only=>[:index]
  #layout :false, :only=>[:show]
  # GET /qr_codes
  # GET /qr_codes.xml
  #
  #
  def index
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    if params[:all_engs]=="1"
      @qr_codes=QrCode.where(:associatable_type=>"Engagement").paginate(:page => @page,:per_page => QrCode::per_page )
    elsif params[:all_users]=="1"
      @users_listing=true
      @qr_codes=QrCode.where(:associatable_type=>"User").paginate(:page => @page,:per_page => QrCode::per_page )
    elsif !params[:user_id].blank?
      @users_listing=true
      @qr_codes=search_user_qrs(@page)
    else
      @qr_codes=search_qrs(@page)
    end
    @templates = Template.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @qr_codes }
    end
  end

  # GET /qr_codes/1
  # GET /qr_codes/1.xml
  def show
    @qr_code = QrCode.find(params[:id]) if params[:id].present?
    @qr_code = QrCode.where(:hash_code=>params[:hash_code]).first if params[:hash_code].present?    
    @engagement=@qr_code.try(:engagement)
    @engagement_type=@engagement.try(:engagement_type)
    @brand=@engagement.try(:campaign).try(:program).try(:business).try(:brand)
    respond_to do |format|
      format.pdf do
        render  :pdf => "qrcode"
      end
      format.html {render :layout=>false}# show.html.erb
      format.xml  { render :xml => @qr_code }
    end
  end

  # GET /qr_codes/new
  # GET /qr_codes/new.xml
  def new
    @qr_code = QrCode.new
    @brands  = Brand.all
    @engagements = Engagement.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @qr_code }
    end
  end

  # GET /qr_codes/1/edit
  def edit
    @qr_code = QrCode.find(params[:id])
    @brands = Brand.all
    @engagements = Engagement.all
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
        format.html { 
          flash[:notice]='Qr code was successfully updated.'
          if @qr_code.associatable_type=="Engagement"
            redirect_to :action=>:index , :engagement_id=>@qr_code.associatable_id
          elsif @qr_code.associatable_type=="User"
            @users_listing=true
            redirect_to :action=>:index , :user_id=>@qr_code.associatable_id
          else
            redirect_to :action=>:index
          end
        }
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
    engagement_id = @qr_code.engagement.id  if @qr_code.engagement
    @qr_code.destroy
    respond_to do |format|
      format.html { redirect_to :action=>:index , :engagement_id =>engagement_id }
      format.xml  { head :ok }
    end
  end

  def panel
    if request.post?
      quantity =  params[:quantity].to_i
      engagement = Engagement.where(:id=>params[:associatable_id]).first
      codes = []
      if params[:associatable_id].blank?
        quantity.times{
          codes << {:code_type => params[:code_type].to_i,:status=>params[:status].to_i,:size=>params[:size].to_i}
        }
        if QrCode.create(codes)
          redirect_to :action=>:index
        end
      else
        #when everything is ok
        quantity.times{
          codes << {:code_type => params[:code_type].to_i,:status=>params[:status].to_i,:associatable_id=>params[:associatable_id].to_i,:associatable_type=>params[:associatable_type],:size=>params[:size].to_i}
        }
        if QrCode.create(codes)
          if params[:associatable_type]=="Engagement"
            redirect_to :action=>:index , :engagement_id=>params[:associatable_id]
          elsif params[:associatable_type]=="User"
            @users_listing=true
            redirect_to :action=>:index , :user_id=>params[:associatable_id]
          else
            redirect_to :action=>:index
          end
        else
          render :action => :panel
        end
      end

    end
    @brands = Brand.all
  end

  def printable
    if request.post?
      @qrcodes = search_qrs.associated_with_engagements

      #@template = Template.find(params[:template_id])

      respond_to do |format|
        engagement_ids = @qrcodes.collect(&:id).to_yaml
        @pj= PrintJob.new(:name=>"#{Time.now.strftime("%m-%d-%Y %H:%M")}" , :log=>engagement_ids)
        if @pj.save
          @qrcodes.update_all(:exported=>true)
          format.pdf do
            if params[:layout].to_i == 1
              render  :pdf => "multi_use_qrcodes_#{Time.now.strftime("%m-%d-%Y %H:%M")}",
                      :template=>"qr_codes/multi_printable.pdf.erb"
            else
              render  :pdf => "single_use_qrcodes_#{Time.now.strftime("%m-%d-%Y %H:%M")}"
            end
          end
        else
          render 404
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

  def update_programs
    @programs = Program.where(:business_id=> params[:id])

    respond_to do |format|
      format.js
    end

  end

   def update_campaigns
    @campaigns= Campaign.where(:program_id=> params[:id])

    respond_to do |format|
      format.js
    end

  end

  def update_engagements
    @engagements = Engagement.where(:campaign_id=> params[:id])
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

  def search_qrs(page)
    search = {}

    search = {:associatable_id =>params[:engagement_id]}            unless params[:engagement_id].blank?
    unless params[:print_job_id].blank?
      pj = PrintJob.where(:id=>params[:print_job_id]).first
      qr_code_ids = YAML.load(pj.log)               if pj.respond_to? :log
      search = search.merge({:id => qr_code_ids })  unless qr_code_ids.blank?
      p qr_code_ids.inspect
    end
    search = search.merge({:status=>params[:status]})             unless params[:status].blank?
    search = search.merge({:code_type=>params[:code_type]})       unless params[:code_type].blank?
    QrCode.where(search).paginate(:page => page,:per_page => QrCode::per_page )
  end
  
  def search_user_qrs(page)
    search = {}
    search = {:associatable_id =>params[:user_id]}
    QrCode.where(search).paginate(:page => page,:per_page => QrCode::per_page )
  end
  
  def check_code_status
    all_logs=Log.select("user_id,created_at,place_id,engagement_id").where("qr_code_id=#{params[:id]}")
    users_count=Log.select("count(DISTINCT user_id) as no_of_users").where("qr_code_id=#{params[:id]}").first
    logs=all_logs[params[:index].to_i,all_logs.size]
    response_text=""
    result={}  
    logs.collect{ |log| 
      user=User.find(log.user_id)
      user_uid=user.email.split("@").first
      engagement=Engagement.where(:id=>log.engagement_id).first
      location_name=Place.where(:id=>log.place_id).first.try(:name).try(:capitalize)
      location_name=engagement.try(:campaign).try(:program).try(:business).try(:brand).try(:name) if location_name.nil?
      engagement_text= engagement.engagement_type.is_visit ? "visited #{location_name}" : "enjoyed a/an #{engagement.name.gsub("Buy ","")}"
      response_text+="<div class=\"usr_com\"><div class=\"toggle_link\"><a class=\"toggle_p selected\" style=\"color:red\" href=\"javascript:void(0)\">Feed View</a><a class=\"toggle_a\" href=\"javascript:void(0)\">Transaction View</a></div><div class=\"feed_entry\"><img src=\"https://graph.facebook.com/#{user_uid}/picture\"/><p> #{user.try(:full_name)} was @ #{location_name} at #{log.created_at.strftime("%I:%M %p")} on #{log.created_at.strftime("%b %d , %Y")}. #{user.try(:full_name).split(' ').first} #{engagement_text} and scored  +#{engagement.amount} points on their tab @ #{location_name} by going out with Cashbury</p></div><div class=\"transaction_details\" style=\"display:none\">Hello</div></div>"
      #735570560 my uid
      #520370946 ahmed uid
    }
    result[:no_of_scanning]=all_logs.size.to_s
    result[:no_of_users]=users_count.no_of_users
    result[:index]=params[:index].to_i+logs.size
    result[:response_text]=response_text
    if request.xhr?
      render :json=>result.to_json
    end
  end
  
  def prepare_filters_data
    @print_jobs   ||= PrintJob.all
    @brands       ||= Brand.all
    @businesses   ||= Business.all
    @engagements  ||= Engagement.all
    @programs     ||= Program.all
    @campaigns    ||= Campaign.all
  end
end
