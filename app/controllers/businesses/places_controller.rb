class Businesses::PlacesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :find_business 
  before_filter :prepare_business_items , :only => [ :new , :create , :edit , :update]
  before_filter :prepare_hours , :only => [ :new , :create , :edit , :update]
  def index
    @places = @business.places
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @places }
      format.json { render :text => @places.to_json}
    end
  end
  
  def show
    @place = Place.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml => @places }
      format.json { render :text => @places.to_json}
    end
  end
  
  def new
    @place=@business.places.build
    @place.build_address
    @open_hours={}
    ENABLE_DELAYED_UPLOADS ? 3.times { @place.tmp_images.build} : 3.times { @place.place_images.build}
  end
  
  def create  
    @place =  @business.places.build(params[:place])
    @place.items_list = params[:place][:items_list] unless params[:place][:items_list].blank?
    @place.tag_list = params[:place][:tag_list]  unless params[:place][:tag_list].nil? || params[:place][:tag_list].empty?
    @place.add_item(params[:item]) unless params[:item].nil? || params[:item][:name].blank?
    @place.add_open_hours(params[:open_hour])
    if @place.save
      flash[:notice] = "Successfully created place."
      redirect_to business_place_url(@business,@place)
    else
      @place.build_address(params[:place][:address_attributes])
      @open_hours=params[:open_hour]
      ENABLE_DELAYED_UPLOADS ? 3.times { @place.tmp_images.build} : 3.times { @place.place_images.build}
      render :action => 'new'
    end
  end
  
  def edit
    @place = Place.find(params[:id])
    ENABLE_DELAYED_UPLOADS ? 3.times { @place.tmp_images.build} : 3.times { @place.place_images.build}
  end
  
  def update
    @place = Place.find(params[:id])
    @place.tag_list = params[:place][:tag_list]  unless params[:place][:tag_list].nil? || params[:place][:tag_list].empty?
    @place.items_list = params[:place][:items_list] unless params[:place][:items_list].blank?
    @place.add_item(params[:item]) unless params[:item].nil? || params[:item][:name].blank?
    @place.add_open_hours(params[:open_hour])
    if @place.update_attributes(params[:place])
      flash[:notice] = "Successfully updated place."
      redirect_to business_place_url(@business,@place)
    else
      ENABLE_DELAYED_UPLOADS ? 3.times { @place.tmp_images.build} : 3.times { @place.place_images.build}
      render :action => 'edit'
    end
  end
  
  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    flash[:notice] = "Successfully destroyed place."
    redirect_to business_places_url(@business)
  end
  
  private
  def find_business
    @business = Business.find(params[:business_id])
  end
  def prepare_business_items
    @items = @business.items
    @place = Place.where(:id => params[:id]).first unless params[:id].nil?
    @items = @business.items | @place.items  if @place # Merging the Business items with Place items.
  end
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
