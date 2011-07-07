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
        params[:is_primary]=true if current_user.sign_in_count <=1
        @place = Place.save_place_by_geolocation(params,current_user)
        if @place.save
          redirect_to :action=>:open_sign, :id=>@place.id
        end
      end
    #else
      #redirect to root
    #end
  end


  def open_sign
    @place = Place.where(:user_id=> current_user.id, :id=>params[:id]).limit(1).first
    if @place && request.post?
      @place.add_open_hours(params[:open_hour])
      if @place.save
        redirect_to :action=>:set_rewards
      else
        redirect_to :action=>:open_hour , :id=>@place.id
      end
    end
  end

  def set_rewards

  end

  def get_places
    @places ||= Place.where(:user_id=>current_user.id)
  end
end
