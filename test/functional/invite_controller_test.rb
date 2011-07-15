require 'test_helper'

class InviteControllerTest < ActionController::TestCase
  test "should get friends" do
    get :friends
    assert_response :success
  end

end
