class BusinessesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  
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
    ENABLE_DELAYED_UPLOADS ? 3.times { @business.tmp_images.build} : 3.times { @business.business_images.build} 
  end
  
  def create
    @business = Business.new(params[:business])
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
      ENABLE_DELAYED_UPLOADS ? 3.times { @business.tmp_images.build} : 3.times { @business.business_images.build}
      render :action => 'new'
    end
  end
  
  def edit
    @brands  = Brand.all
    @business = Business.find(params[:id])
    @categories = Category.all
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
    @cities = City.where(:country_id=> params[:id])
    @selector_id=params[:selector_id]
    respond_to do |format|
      format.js 
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
end
