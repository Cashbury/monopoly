class Users::BusinessesController < ApplicationController
  layout "businessend"

  def index
  end

  def show
  end

  def primary_place
    #if current_user.sign_in_count <= 1
      if request.post?
        if Place.save_place_by_geolocation(params,current_user)
          redirect_to :action=>:set_rewards
        else
          redirect_to root_url
        end
      end
    #else
      #redirect to root
    #end
  end
end
