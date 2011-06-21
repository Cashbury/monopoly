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




  def add_sign_up_path_for(resource_or_scope)
    y resource_or_scope
    "http://google.com"
  end


  def after_sign_in_path_for(resource_or_scope)
    if current_user.role? Role::AS[:principal]
      businesses_url
    elsif (current_user.role? Role::AS[:super_admin]) || (current_user.role? Role::AS[:admin])
      businesses_url
    elsif current_user.role? Role::AS[:mobi]
      businesses_url
    else
      super
    end
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
