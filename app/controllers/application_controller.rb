class ApplicationController < ActionController::Base
	#protect_from_forgery
	before_filter :authenticate_user!,:require_admin
	
	protected
	def require_admin
		unless current_user.nil? || current_user.admin? 
			sign_out current_user
			redirect_to new_user_session_path, :alert => t(:not_authorized) 
			return false
		else
			return true
		end
	end
end
