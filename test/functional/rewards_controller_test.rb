require 'test_helper'

class RewardsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user=Factory.create(:user,:admin=>true)
    @user.confirm!
    sign_in @user
    @reward = Factory.create(:reward)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rewards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reward" do
    assert_difference('Reward.count') do
      post :create, :reward => @reward.attributes
    end

    assert_redirected_to reward_path(assigns(:reward))
  end

  test "should show reward" do
    get :show, :id => @reward.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @reward.to_param
    assert_response :success
  end

  test "should update reward" do
    put :update, :id => @reward.to_param, :reward => @reward.attributes
    assert_redirected_to reward_path(assigns(:reward))
  end

  test "should destroy reward" do
    assert_difference('Reward.count', -1) do
      delete :destroy, :id => @reward.to_param
    end

    assert_redirected_to rewards_path
  end
end
