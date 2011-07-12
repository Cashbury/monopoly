class Users::RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::InternalHelpers

	layout :set_diff_layout

	def create
    respond_to do |format|
			format.html {
				super
			}

			format.xml { #request from iphone  (regular signup)
				@user = User.new(:email=>params[:email],
                         :password=>params[:password],
                         :password_confirmation =>params[:password],
                         :first_name=>params[:first_name],
                         :last_name=>params[:last_name])
				if @user.save!
					render :xml => @user.to_xml(:only=>[:id,:email,:first_name,:last_name,:authentication_token]), :status=>200
				else
					render :xml => {:error=>@user.errors.full_messages.join(',')}, :status=>200
				end
			}
		end
  end


	def set_diff_layout
		template = "businessend"
		template = "application" if action_name =="new" && resource.try(:role?,"admin")
		template
	end

end
