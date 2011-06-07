require 'test_helper'

class LoyalCustomersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user=Factory.create(:user,:admin=>true)
    @user.confirm!
    sign_in @user
  end
  test "the truth" do
    assert true
  end
end
