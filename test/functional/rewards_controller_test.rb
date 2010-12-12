require 'test_helper'

class RewardsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Reward.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Reward.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Reward.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to reward_url(assigns(:reward))
  end
  
  def test_edit
    get :edit, :id => Reward.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Reward.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Reward.first
    assert_template 'edit'
  end

  def test_update_valid
    Reward.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Reward.first
    assert_redirected_to reward_url(assigns(:reward))
  end
  
  def test_destroy
    reward = Reward.first
    delete :destroy, :id => reward
    assert_redirected_to rewards_url
    assert !Reward.exists?(reward.id)
  end
end
