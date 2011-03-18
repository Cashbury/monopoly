class Users::SessionsController < Devise::SessionsController
	before_filter :require_no_authentication,:only=>[:create]
	
	def create
    respond_to do |format|  
			format.html { super }  
			format.xml { #request from iphone  
				@user=User.find_by_email(params[:email])
				if @user.nil?
    			@user = User.new(:email=>params[:email],
                           :password=>params[:password],
                           :password_confirmation =>params[:password],
                           :full_name=>params[:full_name])
					if @user.save!
						sign_in @user
						render :xml => current_user.to_xml(:only=>[:id,:authentication_token]),:status=>200
					else
						render :text => @user.errors.full_messages,:status=>500
					end
        else
					sign_in @user
					#puts ">>>>>>>>>>>>#{current_user.authentication_token}"
					render :xml => current_user.to_xml(:only=>[:id] ),:status=>200   										   
				end  
			}  
		end  
  end
    
  def destroy  
    super  
  end
end
