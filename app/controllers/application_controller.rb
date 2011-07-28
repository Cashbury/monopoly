class ApplicationController < ActionController::Base
	#protect_from_forgery

  helper_method :current_user
  #for bypassing authorization beside devise controllers
  #enable_authorization :unless => :devise_controller?

  # for gracefully handling the accessDenied Expection
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end


  def after_sign_in_path_for(resource_or_scope)
    if current_user.role? Role::AS[:principal] && !(current_user.role? Role::AS[:admin])
      primary_place_users_businesses_url
    elsif (current_user.role? Role::AS[:admin])
      businesses_url
    elsif current_user.role? Role::AS[:consumer]
      #check here for he state of the application
      invite_friends_url
    else
      root_url
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


  protected
	def require_admin
   #unless current_user.nil? || current_user.admin?
      #sign_out current_user
      #redirect_to new_user_session_path, :alert => t(:not_authorized)
      #return false
    #else
      #return true
    #end
    true
	end
end
