require 'spec_helper'

describe Users::ProfileController do
  before(:each) do     
     @user = create_user_and_sign_in
  end

  describe "Put 'update' with valid attributes" do
    it "should update information successfully" do
      #request.env['CONTENT_TYPE'] = 'application/xml'
      put :update, user: { first_name: "Basayel" }, id: @user.id
      assigns(:user).should_not be_nil
      assigns(:user).first_name.should == "Basayel"
      response.headers["Content-Type"].should include("application/xml")
      response.should render_template("users/sessions/create")
    end
  end

end