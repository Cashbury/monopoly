class Users::PasswordsController < Devise::PasswordsController
	def create
    respond_to do |format|  
			format.html { super }  
			format.xml { #request from iphone 
				self.resource = resource_class.send_reset_password_instructions(params[resource_name])
    		if resource.errors.empty?
    			render :xml => self.resource.to_xml(:only=>[:email]),:status=>200
    		else
      		render :xml => {:error=>self.resource.errors.full_messages.join(',')},:status=>200
    		end
			}  
		end  
  end
end
