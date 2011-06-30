class Users::BusinessesController < ApplicationController
  layout "businessend"
  before_filter :authenticate_user!
  before_filter :get_places
  before_filter :prepare_hours , :only=>:open_sign

  def index
  end

  def show
  end

  def primary_place
    #if current_user.sign_in_count <= 1
      if request.post?
        @place = Place.save_place_by_geolocation(params,current_user)
        if @place
          redirect_to :action=>:open_sign, :params=>{:id=>@place.id}
        else
          redirect_to root_url
        end
      end
    #else
      #redirect to root
    #end
  end


  def open_sign
    @place = Place.find_by_user_id(current_user.id)
    if @place && request.post?
      @place.add_open_hours(params[:open_hour])
      if @place.save
        redirect_to :action=>:set_rewards
      end
    end
  end

  def set_rewards

  end

  def get_places
    @places ||= Place.where(:user_id=>current_user.id)
  end
end
