require 'test_helper'

class UsersSnapsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user=Factory.create(:user,:admin=>true)
    @user.confirm!
    sign_in @user
  end
  test "should get index" do
    get :index
    assert_response :success
  end
end
