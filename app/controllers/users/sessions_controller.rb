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
                             :first_name=>params[:first_name],
                             :last_name=>params[:last_name],
                             :username=>params[:username],
                             :is_fb_account=>true)
						if @user.confirm!
							@user.ensure_authentication_token!
							sign_in @user
							render_success_with_user(@user)
						else
							render :xml => {:error=>@user.errors.full_messages.join(',')},:status=>200
						end
					elsif is_valid_user
					  @user.ensure_authentication_token!
						sign_in @user
						render_success_with_user(@user)
					else
						render :xml => {:error=>'Invalid email/password'},:status=>200
					end
      	elsif !is_valid_user
      		render :xml => {:error=>"Invalid email/password"},:status=>200
      	else
        	@user.reset_authentication_token!
					sign_in @user
					render_success_with_user(@user)   										   
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
  
  def render_success_with_user(user)
    render :xml => user.to_xml(:only=>[:id,:email,:first_name,:last_name,:authentication_token,:username] ),:status=>200
  end
end
