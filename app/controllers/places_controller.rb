class PlacesController < ApplicationController
  def index
    @places = Place.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @places }
      format.json { render :text => @places.to_json }
    end
  end
  
  def for_businessid
		@places = Place.where("business_id = ?", params[:id]).sort_by{ |k| k['name'] }    
		respond_to do |format|
			format.json  { render :json => @places }      
		end
	end
end
