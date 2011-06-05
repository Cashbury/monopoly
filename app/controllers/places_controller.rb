class PlacesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_hours , :only => [ :new , :create , :edit , :update]
  def index
    @places = Place.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @places }
      format.json { render :text => @places.to_json }
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
    @place=Place.new
    @place.build_address
    ENABLE_DELAYED_UPLOADS ? 3.times { @place.tmp_images.build} : 3.times { @place.place_images.build}
  end
  
  def create  
    puts "PARAMS: #{params[:place]}"
    @place = Place.new(params[:place])
    @place.tag_list = params[:place][:tag_list]  unless params[:place][:tag_list].nil? || params[:place][:tag_list].empty?
    @place.add_open_hours(params[:open_hour])
    @place.valid?
    puts "ERRORS:  #{@place.errors.full_messages.join(',')}"
    if @place.save
      flash[:notice] = "Successfully created place."
      redirect_to place_url(@place)
    else
      @place.build_address(params[:place][:address_attributes])
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
    @place.add_open_hours(params[:open_hour])
    if @place.update_attributes(params[:place])
      flash[:notice] = "Successfully updated place."
      redirect_to place_url(@place)
    else
      ENABLE_DELAYED_UPLOADS ? 3.times { @place.tmp_images.build} : 3.times { @place.place_images.build}
      render :action => 'edit'
    end
  end
  
  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    flash[:notice] = "Successfully destroyed place."
    redirect_to places_url
  end
  
  def for_businessid
		@places = Place.where("business_id = ?", params[:id]).sort_by{ |k| k['name'] }    
		respond_to do |format|
			format.json  { render :json => @places }      
		end
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
