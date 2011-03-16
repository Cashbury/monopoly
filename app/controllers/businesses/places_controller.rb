class Businesses::PlacesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :find_business
  
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
    @place = Place.new
  end
  
  def create
    @place = Place.new(params[:place])
    if @place.save
      flash[:notice] = "Successfully created place."
      redirect_to business_place_url(@business,@place)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @place = Place.find(params[:id])
  end
  
  def update
    @place = Place.find(params[:id])
    if @place.update_attributes(params[:place])
      flash[:notice] = "Successfully updated place."
      redirect_to business_place_url(@business,@place)
    else
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
    @business = Business.where(params[:business_id]).first
  end
end
