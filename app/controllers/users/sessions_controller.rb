class Users::SessionsController < Devise::SessionsController
	def create
    respond_to do |format|  
			format.html { super }  
			format.xml { #request from iphone 
				@user=User.find_by_email(params[:email]) 
				is_valid_user=!@user.nil? && @user.valid_password?(params[:password])
				if !params[:email].match(/\b@facebook.com.fake\b/).nil? #login from facebook
					if @user.nil? #new account
    				@user = User.new(:email=>params[:email],
                           	 :password=>params[:password],
                             :password_confirmation =>params[:password],
                             :full_name=>params[:full_name])
						@user.ensure_authentication_token!
						if @user.save!
							sign_in @user
							render :xml => current_user.to_xml(:only=>[:id,:email,:full_name,:authentication_token]),:status=>200
						else
							render :xml => {:error=>@user.errors.full_messages.join(',')},:status=>200
						end
					elsif is_valid_user
						sign_in @user
						render :xml => current_user.to_xml(:only=>[:id,:email,:full_name,:authentication_token]),:status=>200
					else
						render :xml => {:error=>'Invalid email/password'},:status=>200
					end
      	elsif !is_valid_user
      		render :xml => {:error=>"Invalid email/password"},:status=>200
      	else
        	@user.reset_authentication_token!
					sign_in @user
					render :xml => current_user.to_xml(:only=>[:id,:email,:full_name,:authentication_token] ),:status=>200   										   
				end  
			}  
		end  
  end
    
  def destroy  
		respond_to do |format|  
			format.html { super }  
			format.xml { #request from iphone  
				if current_user
					user=current_user
					user.authentication_token=nil
					sign_out user
					if user.save!
						render :text=>"User Signed out",:status=>200
					else
						render :text => user.errors.full_messages,:status=>500
					end
				else
					render :text => "User already signed out",:status=>500
			 	end
			}  
		end   
  end
end
