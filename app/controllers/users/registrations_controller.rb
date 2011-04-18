class Users::RegistrationsController < Devise::RegistrationsController
	def create
    respond_to do |format|  
			format.html { super }  
			format.xml { #request from iphone  
				@user = User.new(:email=>params[:email],
                         :password=>params[:password],
                         :password_confirmation =>params[:password],
                         :full_name=>params[:full_name])
				if @user.save!
					render :xml => @user.to_xml(:only=>[:email]), :status=>200
				else
					render :xml => {:error=>@user.errors.full_messages.join(',')}, :status=>200
				end 
			}  
		end  
  end
end
