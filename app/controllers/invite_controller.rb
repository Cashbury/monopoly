class InviteController < ApplicationController

  before_filter :log_cookies

  def friends
  end


  def show
    @user = User.find_by_share_id(params[:id])
    if @user
      cookies[:origin_user_share] = params[:id]
    end
    redirect_to new_user_registration_url
  end
end
