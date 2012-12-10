class Users::ProfileController < Users::BaseController
  include Devise::TestHelpers
  # Update users profile details
  def update
    @user = params[:id].present? ? User.find(params[:id]) : current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.xml { render template: "users/sessions/create"}
      else
        format.xml { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

end