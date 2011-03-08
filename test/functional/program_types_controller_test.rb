require 'test_helper'

class ProgramTypesControllerTest < ActionController::TestCase
  setup do
  	user=Factory.create(:user)
  	sign_in user
    @program_type = Factory.create(:program_type)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_type" do
    assert_difference('ProgramType.count') do
      post :create, :program_type => @program_type.attributes
    end

    assert_redirected_to program_type_path(assigns(:program_type))
  end

  test "should show program_type" do
    get :show, :id => @program_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @program_type.to_param
    assert_response :success
  end

  test "should update program_type" do
    put :update, :id => @program_type.to_param, :program_type => @program_type.attributes
    assert_redirected_to program_type_path(assigns(:program_type))
  end

  test "should destroy program_type" do
    assert_difference('ProgramType.count', -1) do
      delete :destroy, :id => @program_type.to_param
    end

    assert_redirected_to program_types_path
  end
end
