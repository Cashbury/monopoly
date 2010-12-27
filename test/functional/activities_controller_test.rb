require File.dirname(__FILE__) + '/../test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  def test_create_invalid
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Business.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to business_url(assigns(:business))
  end
end