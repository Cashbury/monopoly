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
      3.times {place.place_images.build}
    end
    3.times { @business.business_images.build}
    @business.places.each do | place|
      place.address = Address.new
    end
  end
  
  def create
    @business = Business.new(params[:business])
    set_tag_lists_for_business_places(@business)   
    if @business.save
      flash[:notice] = "Successfully created business."
      redirect_to @business
    else
    	@brands  = Brand.all
    	@categories = Category.all
    	3.times { @business.places.build }
    	3.times { @business.business_images.build}
      render :action => 'new'
    end
  end
  
  def edit
    @brands  = Brand.all
    @business = Business.find(params[:id])
    @categories = Category.all
    3.times { @business.places.build }
    @business.places.each do |place|
      3.times {place.place_images.build}
    end
    @business.places.each do | place|
      1.times { place.items.build }
     end
    (3-@business.business_images.size).times { @business.business_images.build}
   end
  
  def update
    @brands  = Brand.all
    @categories = Category.all
    @business = Business.find(params[:id])
    
    if @business.update_attributes(params[:business])
       flash[:notice] = "Successfully updated business."
       redirect_to @business
    else
      (3-@business.business_images.size).times { @business.business_images.build}
      render :action => 'edit'
    end
   end
  
  def destroy
    @business = Business.find(params[:id])
    @business.destroy
    flash[:notice] = "Successfully destroyed business."
    redirect_to businesses_url
  end
  
  private
  def set_tag_lists_for_business_places(business)
    business.places.each_with_index do |place,index|
      place.tag_list = params[:business][:places_attributes][index.to_s][:tag_list] 
    end
  end
end
