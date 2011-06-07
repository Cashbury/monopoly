require 'test_helper'

class Businesses::Programs::Campaigns::EngagementsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user=Factory.create(:user,:admin=>true)
    @user.confirm!
    sign_in @user
    @engagement = Factory.create(:engagement)
    @campaign=@engagement.campaign
    @program =@campaign.program
    @business=@program.business
  end

  test "should get index" do
    get :index,{:campaign_id=>@campaign.id,:program_id=>@program.id,:business_id=>@business.id}
    assert_response :success
    assert_not_nil assigns(:engagements)
  end

  test "should get new" do
    get :new,{:campaign_id=>@campaign.id,:program_id=>@program.id,:business_id=>@business.id}
    assert_response :success
  end
  
  test "should create engagement" do
    assert_difference('Engagement.count') do
      post :create, {:campaign_id=>@campaign.id,:program_id=>@program.id,:business_id=>@business.id,:engagement => @engagement.attributes}
    end
    assert_redirected_to business_program_campaign_engagement_path(@business,@program,@campaign,assigns(:engagement))
  end
  
  test "should show engagement" do
    get :show, {:campaign_id=>@campaign.id,:program_id=>@program.id,:business_id=>@business.id,:id => @engagement.to_param}
    assert_response :success
  end
   
  test "should get edit" do
    get :edit, {:campaign_id=>@campaign.id,:program_id=>@program.id,:business_id=>@business.id,:id => @engagement.to_param}
    assert_response :success
  end
   
  test "should update engagement" do
    put :update, {:campaign_id=>@campaign.id,:program_id=>@program.id,:business_id=>@business.id,:id => @engagement.to_param, :engagement => @engagement.attributes}
    assert_redirected_to business_program_campaign_engagement_path(@business,@program,@campaign,assigns(:engagement))
  end
    
  test "should destroy engagement" do
     assert_difference('Engagement.count', -1) do
       delete :destroy, {:campaign_id=>@campaign.id,:program_id=>@program.id,:business_id=>@business.id,:id => @engagement.to_param}
     end
     assert_redirected_to business_program_campaign_engagements_path
   end
end
