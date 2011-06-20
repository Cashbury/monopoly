class Users::RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::InternalHelpers
	def create
    respond_to do |format|
			format.html { super }
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


  def business_signup
    #hack

    if request.post?
      build_resource
      y resource
      if resource.save!
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, resource)
          respond_with resource, :location => redirect_location(resource_name, resource)
        else
          set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
          expire_session_data_after_sign_in!
          respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords(resource)
        #respond_with_navigational(resource) { render_with_scope :new }
      end
    end
    resource= build_resource({})
    render :layout=>'frontend'
  end
end
