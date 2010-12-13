class PlacesController < ApplicationController
  def index
    @places = Place.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @places }
      format.json { render :text => @places.to_json }
    end
  end
  
  def show
    @place = Place.find_by_long_and_lat(params[:long], params[:lat])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @place }
      format.json { render :text => @place.to_json }
    end
  end
end
