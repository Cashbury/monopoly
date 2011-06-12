class PlacesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show,:for_businessid]
  
  def index
    @places = Place.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @places }
      format.json { render :text => @places.to_json }
    end
  end
  
  def show
    @places=[]
    unless params[:long].blank? and  params[:lat].blank?
			@places = Place.within(DISTANCE,:units=>:km,:origin=>[params[:lat].to_f,params[:long].to_f]).order('distance ASC')
	  else
	  	@places = Place.all
    end
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
