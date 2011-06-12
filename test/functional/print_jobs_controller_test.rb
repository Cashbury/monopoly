require 'test_helper'

class PrintJobsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user=Factory.create(:user,:admin=>true)
    @user.confirm!
    sign_in @user
  end
  test "the truth" do
    assert true
  end
  # setup do
  #   @print_job = print_jobs(:one)
  # end
  # 
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:print_jobs)
  # end
  # 
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create print_job" do
  #   assert_difference('PrintJob.count') do
  #     post :create, :print_job => @print_job.attributes
  #   end
  # 
  #   assert_redirected_to print_job_path(assigns(:print_job))
  # end
  # 
  # test "should show print_job" do
  #   get :show, :id => @print_job.to_param
  #   assert_response :success
  # end
  # 
  # test "should get edit" do
  #   get :edit, :id => @print_job.to_param
  #   assert_response :success
  # end
  # 
  # test "should update print_job" do
  #   put :update, :id => @print_job.to_param, :print_job => @print_job.attributes
  #   assert_redirected_to print_job_path(assigns(:print_job))
  # end

  # test "should destroy print_job" do
  #   assert_difference('PrintJob.count', -1) do
  #     delete :destroy, :id => @print_job.to_param
  #   end
  # 
  #   assert_redirected_to print_jobs_path
  # end
end
