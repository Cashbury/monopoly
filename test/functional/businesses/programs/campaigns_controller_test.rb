require 'test_helper'

class Businesses::Programs::CampaignsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user=Factory.create(:user,:admin=>true)
    @user.confirm!
    sign_in @user
    @campaign = Factory.create(:campaign)
    @program =@campaign.program
    @business=@program.business
  end

  test "should get index" do
    get :index,{:business_id=>@business.id,:program_id=>@program.id}
    assert_response :success
    assert_not_nil assigns(:campaigns)
  end

  test "should get new" do
    get :new,{:business_id=>@business.id,:program_id=>@program.id}
    assert_response :success
  end

  test "should create campaign" do
    assert_difference('Campaign.count') do
      post :create, {:business_id=>@business.id,:program_id=>@program.id,:campaign => @campaign.attributes}
    end

    assert_redirected_to business_program_campaign_path(@business,@program,assigns(:campaign))
  end

  test "should show campaign" do
    get :show, {:business_id=>@business.id,:program_id=>@program.id,:id => @campaign.to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:business_id=>@business.id,:program_id=>@program.id,:id => @campaign.to_param}
    assert_response :success
  end

  test "should update campaign" do
    put :update, {:business_id=>@business.id,:program_id=>@program.id,:id => @campaign.to_param, :campaign => @campaign.attributes}
    assert_redirected_to business_program_campaign_path(@business,@program,assigns(:campaign))
  end

  test "should destroy campaign" do
    assert_difference('Campaign.count', -1) do
      delete :destroy, {:business_id=>@business.id,:program_id=>@program.id,:id => @campaign.to_param}
    end

    assert_redirected_to business_program_campaigns_path(@business,@program)
  end
end
