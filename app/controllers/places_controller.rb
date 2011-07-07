class PlacesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_hours , :only => [ :new , :create , :edit , :update, :get_opening_hours]
  def index
    @places = search_places

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
    @open_hours={}
    ENABLE_DELAYED_UPLOADS ? 3.times { @place.tmp_images.build} : 3.times { @place.place_images.build}
  end

  def create
    @place = Place.new(params[:place])
    @place.tag_list = params[:place][:tag_list]  unless params[:place][:tag_list].nil? || params[:place][:tag_list].empty?
    @place.add_open_hours(params[:open_hour])
    if @place.save
      flash[:notice] = "Successfully created place."
      redirect_to place_url(@place)
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

  def get_opening_hours
    render :json=>@hours
  end

  def for_businessid
		@places = Place.where("business_id = ?", params[:id]).sort_by{ |k| k['name'] }
		respond_to do |format|
			format.json  { render :json => @places }
		end
	end

  def update_places
    brands = current_user.brands.map(&:id)
    biz = Business.where(:brand_id=>brands).map(&:id)

    @users = Place.where(:business_id=>biz).where(['name LIKE ?', "#{params[:term]}%"]).map(&:name)
    render :json => @users
  end

  def prepare_hours
    @hours = []
    7.upto(11) do | i |
      @hours << "#{i}:00 AM"
      @hours << "#{i}:30 AM"
    end
    @hours << "12:00 PM"
    @hours << "12:30 PM"
    1.upto(11) do | i |
      @hours << "#{i}:00 PM"
      @hours << "#{i}:30 PM"
    end
    @hours << "12:00 AM"
    @hours << "12:30 AM"
    return @hours
  end

  private

  def search_places
    search_params ={}
    valid_keys = ["country_id", "city_id"]
    #params = params.select{|key,value| valid_keys.include? key } unless params.blank?
    search_params.merge!({:country_id=> params[:country_id]}) unless params[:country_id].blank?
    search_params.merge!({:city_id=>params[:city_id]}) unless params[:city_id].blank?
    address = Address.where search_params
    places = Place.where :address_id=> address.map(&:id)
    #Place.all if places.blank?
  end
end
