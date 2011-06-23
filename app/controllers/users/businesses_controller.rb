class Users::BusinessesController < ApplicationController
  layout "businessend"

  def index
  end

  def show
  end

  def primary_place
    #if current_user.sign_in_count <= 1
      if request.post?
        @place = Place.new(params[:place].merge(:is_primary=>true))
        @place.user_id = current_user.id
        if @place.save
          redirect_to :action=>:set_rewards
        end
      else
        @place = Place.new
        @place.build_address
      end
    #else
      # redirect_to root_url
    #end

  end
end
