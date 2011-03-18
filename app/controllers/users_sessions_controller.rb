class UsersSessionsController < ApplicationController
  #This class is for quick testing fb connect and should be disabled later
  def login  	
  	@user=User.find_by_email(params[:email])
  	if @user.blank?
    	@user = User.new(:email=>params[:email],
											 :password=>params[:password],
											 :password_confirmation =>params[:password],
    									 :full_name=>params[:full_name])
			@user.save    										   
		end
		sign_in @user
    respond_to do |format|
      format.html
      format.xml { render :xml => @user.to_xml(:only=>[:id]) }
      format.json { render :text => @user.to_json }
    end
  end
  
end