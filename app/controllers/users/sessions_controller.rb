class Users::SessionsController < Devise::SessionsController
	def create
    respond_to do |format|  
			format.html { super }  
			format.xml { #request from iphone 
				@user = User.find_by_email(params[:email]) 
				is_valid_user = !@user.nil? && @user.valid_password?(params[:password])
				if !params[:email].match(/\b@facebook.com.fake\b/).nil? #login from facebook
					if @user.nil? #new account
    				@user = User.new(:email => params[:email],
                           	 :password => params[:password],
                             :password_confirmation => params[:password],
                             :first_name => params[:first_name],
                             :last_name => params[:last_name],
                             :username => params[:username],
                             :is_fb_account => true)
						if @user.confirm!
							@user.ensure_authentication_token!
							sign_in @user
							render_success_with_user(@user)
						else
							render :xml => {:error => @user.errors.full_messages.join(',')}, :status => 200
						end
					elsif is_valid_user
					  @user.ensure_authentication_token!
						sign_in @user
						render_success_with_user(@user)
					else
						render :xml => {:error=>'Invalid email/password'}, :status => 200
					end
      	elsif !is_valid_user
      		render :xml => {:error=>"Invalid email/password"}, :status => 200
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
					user = current_user
					user.authentication_token = nil
					sign_out user
					if user.save!
						render :text => "User Signed out", :status => 200
					else
						render :text => user.errors.full_messages, :status => 500
					end
				else
					render :text => "User already signed out", :status => 500
			 	end
			}  
		end   
  end
  
  def render_success_with_user(user)
    cashier_role = Role.find_by_name(Role::AS[:cashier])
    result = {}
    result[:user] = {}
    if (employee = user.employees.where(:role_id => cashier_role.id).first).present? #is cashier
      result[:user] = user.attributes.select{|k,v| k=="id" || k=="email" || k=="first_name" || k=="last_name" || k=="authentication_token" || k=="username"}
      result[:user][:business_id] = employee.business_id
      business = Business.find(employee.business_id) if employee.business_id
      if business.present?
        result[:user][:brand_name] = business.brand.try(:name)
        result[:user][:brand_image_url] = business.brand.brand_image.photo(:normal) if business.brand.brand_image.present?
        result[:user][:flag_url] = business.country.present? ? URI.escape("http://#{request.host_with_port}#{COUNTRIES_FLAGS_PATH}#{business.country.iso2.to_s.downcase}.png") : nil
        result[:user][:currency_code] = business.currency_code
        result[:user][:currency_symbol] = business.currency_symbol
      end     
      render :xml => result, :status =>200
    else
      render :xml => user.to_xml(:only => [:id,:email,:first_name,:last_name,:authentication_token,:username] ),:status=>200
    end
  end
end
