class BusinessesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_hours , :only => [ :new , :create , :edit , :update]
  before_filter :prepare_business, :only=> [:show, :edit, :update, :destroy, :list_campaign_transactions, :list_enrolled_customers, :list_all_enrolled_customers ]
  skip_before_filter :authenticate_user!, :only=> [:update_cities, :update_countries]
  @@per_page=20

  helper_method :sort_column , :sort_direction

  def index
    @businesses ||= Business.search_by_name(params[:name]).
                          search_by_brand_name(params[:brand_name]).
                          search_by_address("country_id",params[:country_id]).
                          search_by_address("city_id", params[:city_id]).
                          order("#{params[:sort]} #{params[:direction]}").
                          paginate  :page=>params[:page]

    respond_to do |format|
      format.html
      format.xml { render :xml => @businesses }
      format.json { render :text => @businesses.to_json}
    end
  end

  def show
    @categories = Category.all
    @campaigns= @business.list_campaigns
    respond_to do |format|
      format.html
      format.xml { render :xml => @business }
      format.json { render :text => @business.to_json}
    end
  end

  def new
    @brands  = Brand.all
    @business = Business.new
    @categories = Category.all
    3.times { @business.places.build}
    @business.places.each do |place|
      place.build_address
      ENABLE_DELAYED_UPLOADS ? 3.times { place.tmp_images.build} : 3.times { place.place_images.build}
    end
    @business.build_mailing_address
    @business.build_billing_address
    @total=LegalType.count
    @legal_ids=[]
  end

  def create
    @business = Business.new(params[:business])
    @business.places.each_with_index do |place, index|
      place.add_open_hours(params["open_hour_#{index}"])
    end
    @business.tag_list << @business.name
    set_tag_lists_for_business_places(@business)
    if @business.save
      unless params[:legal_ids].empty? || params[:legal_types].empty?
        @business.set_legal_ids(params[:legal_types], params[:legal_ids])
      end
      flash[:notice] = "Successfully created business."
      redirect_to @business
    else
    	@brands  = Brand.all
    	@categories = Category.all
    	3.times { @business.places.build}
      @business.places.each do |place|
        place.build_address
        3.times {place.place_images.build}
      end
      @business.build_mailing_address(params[:business][:mailing_address_attributes])
      @business.build_billing_address(params[:business][:billing_address_attributes])
      render :action => 'new'
    end
  end

  def edit
    @brands  = Brand.all
    @categories = Category.all
    3.times { @business.places.build }
    @business.places.each do |place|
      place.build_address if place.address.nil?
      3.times {place.place_images.build}
    end
    @business.build_mailing_address if @business.mailing_address.nil?
    @business.build_billing_address if @business.billing_address.nil?
    @legal_ids=@business.legal_ids
   end

  def update
    if @business.update_attributes(params[:business])
      LegalId.delete_all("associatable_id=#{@business.id} and associatable_type='Business'")
      unless params[:legal_ids].empty? || params[:legal_types].empty?
        @business.set_legal_ids(params[:legal_types], params[:legal_ids])
      end
      flash[:notice] = "Successfully updated business."
      redirect_to @business
    else
      @brands  = Brand.all
      @categories = Category.all
      @business.build_mailing_address if @business.mailing_address.nil?
      @business.build_billing_address if @business.billing_address.nil?
      render :action => 'edit'
    end
   end

  def destroy
    @business.destroy
    flash[:notice] = "Successfully destroyed business."
    redirect_to businesses_url
  end
  
  def list_campaign_transactions
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @campaign = Campaign.find(params[:c_id])
    @result = Log.list_campaign_transactions(params[:c_id])
                 .paginate(:page => @page,:per_page => @@per_page )
  end
  
  def list_enrolled_customers
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @campaign = Campaign.find(params[:c_id])
    @result = Log.list_enrolled_customers(params[:c_id], params[:place_id])
                       .paginate(:page => @page,:per_page => @@per_page )
  end  
    
    
  def list_all_enrolled_customers
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @type_id= params[:type_id].to_i.zero? ? 0 : params[:type_id].to_i
    @result = @business.list_all_enrolled_customers(@type_id)
                       .paginate(:page => @page,:per_page => @@per_page )
  end    
  
  def update_cities
    @cities = City.where(['name LIKE ?', "#{params[:term]}%"]).
                  limit(20).
                  map{|city| {:id=>city.id, :label=>city.name }}

    @selector_id=params[:selector_id]
    respond_to do |format|
      format.js
    end
  end

  def update_countries
    @cities = Country.where(['name LIKE ?', "#{params[:term]}%"]).map{|con| {:id=>con.id, :label=>con.name }}
    respond_to do |format|
      format.js
    end
  end
  
  def update_currencies
    currency_code=Country.find(params[:country_id]).currency_code
    respond_to do |format|
      format.js {render :text=> currency_code}
    end
  end

  def check_primary_place
    @business = Business.where(params[:id]).first
    respond_to do |f|
      f.js
    end
  end

  def get_users
    valid_keys=[:email, :username, :telephone_number]
    term = "%#{params[:term]}%"
    params.select{|key,value| valid_keys.include? key.to_sym }
    column_type = params[:column_type] || "email"
    @users = User.where([ " #{column_type} like ?", term ]).map{|con| {:id=>con.id, :label=>con.send(column_type) }}
    render :json => @users #| @users2
  end
  
  def get_places
    @places = Place.where(['name LIKE ? ', "#{params[:term]}%"]).map{|con| {:id=>con.id, :label=>con.name }}
    render :json => @places
  end

  def update_users
    @businesses = Business.where :brand_id=> Brand.all.map{|b| b.id }
    respond_to do |format|
      format.js
    end
  end


  def get_engagement
    @engagement = Engagement.find(params[:id])
    respond_to do |f|
      f.xml{render :xml=>@engagement}
      f.json{render :json=>@engagement}
    end
  end

  def auto_business
    if current_user.role? Role::AS[:owner] || true
      brands = current_user.brands.map(&:id)
      @biz = Business.where(:brand_id=>brands).where(['name LIKE ?', "#{params[:term]}%"]).map{|con| {:id=>con.id, :label=>con.name }} unless brands.blank?

    else
      @biz=Business.where(['name LIKE ?', "#{params[:term]}%"]).map{|con| {:id=>con.id,:label=>con.label }}
    end

    render :json => @biz
  end


  private
  def set_tag_lists_for_business_places(business)
    business.places.each_with_index do |place,index|
      if params[:business][:places_attributes][index.to_s][:tag_list]
        place.tag_list = params[:business][:places_attributes][index.to_s][:tag_list]
      end
    end
  end


  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

  def sort_column
    Business.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def prepare_business
    @business = Business.find(params[:id])
  end
    
end
