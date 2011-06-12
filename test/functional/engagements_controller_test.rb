require 'test_helper'

class EngagementsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Engagement.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Engagement.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Engagement.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to engagement_url(assigns(:engagement))
  end
  
  def test_edit
    get :edit, :id => Engagement.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Engagement.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Engagement.first
    assert_template 'edit'
  end

  def test_update_valid
    Engagement.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Engagement.first
    assert_redirected_to engagement_url(assigns(:engagement))
  end
  
  def test_destroy
    engagement = Engagement.first
    delete :destroy, :id => engagement
    assert_redirected_to engagements_url
    assert !Engagement.exists?(engagement.id)
  end
end
