class PlacesController < ApplicationController
  def index
    @places = Place.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @places }
    end
  end
end
