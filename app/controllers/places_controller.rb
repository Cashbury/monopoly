class PlacesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_hours , :only => [ :new , :create , :edit , :update, :get_opening_hours]
  before_filter :set_place , :only =>[:google, :reset_google]

  def index
    @places = search_places

    respond_to do |format|
      format.html
      format.xml { render :xml => @places.to_xml(:methods => [:status]) }
      format.json { render :text => @places.to_xml(:methods => [:status]) }
    end
  end

  def show
    @place = Place.find(params[:id])
    client = Places::Client.new(:api_key => APP_CONFIG["google_api_key"])
    @gplaces =  client.search(:lat=>@place.lat.to_f, :lng=>@place.long.to_f, :name=>@place.name)
    unless @place.google_reference.blank?
      @gplace = client.details(:reference=>@place.google_reference)
    end
    respond_to do |format|
      format.html
      format.xml { render :xml => @place.to_xml(:include => :open_hours) }
      format.json { render :text => @place.to_json(:include => :open_hours)}
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
    @open_hours = @place.open_hours
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
      @open_hours = @place.open_hours
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


  def google
    @place.google_reference = params[:reference_id]
    @place.save!
    redirect_to place_url(@place) , :notice=>"Linked a google place"
  end

  def reset_google
    @place.google_reference = nil
    @place.save!
    redirect_to place_url(@place) , :notice=>"unlinked google place"
  end

  private

  def set_place
    @place ||= Place.where(:id=>params[:id]).limit(1).first
  end

  def search_places
    search_params ={}
    places=[]
    valid_keys = ["country_id", "city_id"]
    #params = params.select{|key,value| valid_keys.include? key } unless params.blank?
    @city     = City.find(params[:city_id])                   unless params[:city_id].blank?
    @country  = Country.find(params[:country_id])             unless params[:country_id].blank?
    #search_params.merge!({:country_id=> params[:country_id]}) unless params[:country_id].blank?
    search_params.merge!({:city_id=>params[:city_id]}) unless params[:city_id].blank?
    unless params[:country_id].blank?
      addresses = Address.joins(:city=>:country).where(search_params)
                                                .where("cities.country_id=#{params[:country_id]}") 
    else
      addresses = Address.joins(:city=>:country).where(search_params)                                          
    end
    places = Place.where :address_id=> addresses.map(&:id) if addresses.present?
    places = Place.all if places.empty?
    places
  end
end
