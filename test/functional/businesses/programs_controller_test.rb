require 'test_helper'

class Businesses::ProgramsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user=Factory.create(:user,:admin=>true)
    @user.confirm!
    sign_in @user
    @program =Factory.create(:program)
    @business=@program.business
  end

  test "should get index" do
    get :index,{:business_id=>@business.id}
    assert_response :success
    assert_not_nil assigns(:programs)
  end

  test "should get new" do
    get :new,{:business_id=>@business.id}
    assert_response :success
  end

  test "should create program" do
    assert_difference('Program.count') do
      @program=Factory.build(:program)
      post :create, {:business_id=>@business.id,:program => @program.attributes}
    end

    assert_redirected_to business_program_path(@business,assigns(:program))
  end

  test "should show program" do
    get :show, {:business_id=>@business.id,:id => @program.to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:business_id=>@business.id,:id => @program.to_param}
    assert_response :success
  end

  test "should update program" do
    put :update, {:business_id=>@business.id,:id => @program.to_param, :program => @program.attributes}
    assert_redirected_to business_program_path(@business,assigns(:program))
  end

  test "should destroy program" do
    assert_difference('Program.count', -1) do
      delete :destroy, {:business_id=>@business.id,:id => @program.to_param}
    end

    assert_redirected_to business_programs_path(@business)
  end
end
