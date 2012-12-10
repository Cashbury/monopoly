class Users::BaseController < ApplicationController
	before_filter :authenticate_user!, :check_user_activation
	
	def check_user_activation
	  if !current_user.is_active? 
      respond_to do |format|
        format.xml { render text: "User not active" , status: 500 }
      end
    end
  end
  
  def respond_with_error(error)
		respond_to do |format|
			format.xml { render text: error, status: 500 }
		end
  end
end