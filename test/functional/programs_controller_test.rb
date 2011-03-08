require 'test_helper'

class ProgramsControllerTest < ActionController::TestCase
  setup do
  	user=Factory.create(:user)
  	sign_in user
  	@program = Factory.create(:program,:business=>Factory.create(:business),
  														:type_id=>Factory.create(:program_type).id)
  	account=Factory.create(:account,:user=>user,:program=>@program)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:programs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program" do
    assert_difference('Program.count') do
      post :create, :program => @program.attributes
    end

    assert_redirected_to program_path(assigns(:program))
  end

  test "should show program" do
    get :show, :id => @program.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @program.to_param
    assert_response :success
  end

  test "should update program" do
    put :update, :id => @program.to_param, :program => @program.attributes
    assert_redirected_to program_path(assigns(:program))
  end

  test "should destroy program" do
    assert_difference('Program.count', -1) do
      delete :destroy, :id => @program.to_param
    end

    assert_redirected_to programs_path
  end
end
