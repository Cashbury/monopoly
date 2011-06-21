class BusinessesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_hours , :only => [ :new , :create , :edit , :update]

  def index
    @businesses = Business.all
    respond_to do |format|
      format.html
      format.xml { render :xml => @businesses }
      format.json { render :text => @businesses.to_json}
    end
  end

  def show
    @business = Business.find(params[:id])
    @categories = Category.all
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
    #need to disable business images
    ENABLE_DELAYED_UPLOADS ? 3.times { @business.tmp_images.build} : 3.times { @business.business_images.build}
  end

  def create
    @business = Business.new(params[:business])
    @business.places.each_with_index do |place, index|
      place.add_open_hours(params["open_hour_#{index}"])
    end
    @business.tag_list << @business.name
    set_tag_lists_for_business_places(@business)
    if @business.save
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
      ENABLE_DELAYED_UPLOADS ? 3.times { @business.tmp_images.build} : 3.times { @business.business_images.build}
      render :action => 'new'
    end
  end

  def edit
    @brands  = Brand.all
    @business = Business.find(params[:id])
    @categories = Category.all
    3.times { @business.places.build }
    @business.places.each do |place|
      place.build_address if place.address.nil?
      3.times {place.place_images.build}
    end
    @business.build_mailing_address if @business.mailing_address.nil?
    @business.build_billing_address if @business.billing_address.nil?
    ENABLE_DELAYED_UPLOADS ? 3.times { @business.tmp_images.build} : 3.times { @business.business_images.build}
   end

  def update
    @business = Business.find(params[:id])
    if @business.update_attributes(params[:business])
       flash[:notice] = "Successfully updated business."
       redirect_to @business
    else
      @brands  = Brand.all
      @categories = Category.all
      @business.build_mailing_address if @business.mailing_address.nil?
      @business.build_billing_address if @business.billing_address.nil?
      ENABLE_DELAYED_UPLOADS ? 3.times { @business.tmp_images.build} : 3.times { @business.business_images.build}
      render :action => 'edit'
    end
   end

  def destroy
    @business = Business.find(params[:id])
    @business.destroy
    flash[:notice] = "Successfully destroyed business."
    redirect_to businesses_url
  end

  def update_cities
    @cities = City.where(:country_id=> params[:id] )
                  .where(['name LIKE ?', "#{params[:term]}%"])
                  .map{|city| {:id=>city.id, :label=>city.name }}

    @selector_id=params[:selector_id]
    respond_to do |format|
      format.js
    end

  end

  def check_primary_place
    @business = Business.where(params[:id]).first
    respond_to do |f|
      f.js
    end
  end


  private
  def set_tag_lists_for_business_places(business)
    business.places.each_with_index do |place,index|
      if params[:business][:places_attributes][index.to_s][:tag_list]
        place.tag_list = params[:business][:places_attributes][index.to_s][:tag_list]
      end
    end
  end

  # Please ... use models !!
  def prepare_hours
    @hours = []
    12.downto(1) do | i |
       @hours << "#{i}:00 AM"
       @hours << "#{i}:30 AM"
    end
    12.downto(1) do | i |
       @hours << "#{i}:00 PM"
       @hours << "#{i}:30 PM"
    end
    return @hours
  end
end
