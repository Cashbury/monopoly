class ApplicationController < ActionController::Base
	#protect_from_forgery
  #before_filter :check_permissions
  helper_method :current_user
  #for bypassing authorization beside devise controllers
  #enable_authorization :unless => :devise_controller?

  # for gracefully handling the accessDenied Expection
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  #def check_permissions
  #  authorize! :manage, current_user
  #end
  #For production loggin
  #unless Rails.application.config.consider_all_requests_local
    #rescue_from Exception, :with => :render_error
    #rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    #rescue_from AbstractController::ActionNotFound, :with => :render_not_found
    #rescue_from ActionController::RoutingError, :with => :render_not_found
    #rescue_from ActionController::UnknownController, :with => :render_not_found
    #rescue_from ActionController::UnknownAction, :with => :render_not_found
  #end

  #def render_error e
      #render :text => "#{e.message} -- #{e.class}<br/>#{e.backtrace.join("<br/>")}"
  #end

  #def render_not_found e
    #render :text => "#{e.message} -- #{e.class}<br/>#{e.backtrace.join("<br/>")}"
  #end

  #def add_sign_up_path_for(resource_or_scope)
  #end

  def after_sign_in_path_for(resource_or_scope)
    if current_user.role? Role::AS[:principal] && !(current_user.role? Role::AS[:admin])
      primary_place_users_businesses_url
    elsif (current_user.role? Role::AS[:admin]) || (current_user.role? Role::AS[:operator])
      businesses_url
    elsif current_user.role? Role::AS[:consumer]
      # for now they go straight to transactions page
      user_transactions_path(current_user)
    else
      root_url
    end
  end

  def prepare_hours
    @hours = []
    @hours << "12:00 AM"
    @hours << "12:30 AM"
    1.upto(11) do |i|
      @hours << "#{i}:00 AM"
      @hours << "#{i}:30 AM"      
    end
    @hours << "12:00 PM"
    @hours << "12:30 PM"
    1.upto(11) do |i|
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
