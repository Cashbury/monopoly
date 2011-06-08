require 'test_helper'

class Businesses::CampaignsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user=Factory.create(:user,:admin=>true)
    @user.confirm!
    sign_in @user
    @country=Factory.create(:country,:name=>"Egypt",:abbr=>"EG")
    @city=Factory.create(:city,:name=>"Alexandria",:lat=>"31.2135",:lng=>"29.9443",:country=>@country)
    @address=Factory.create(:address,:city_id=>@city.id,:country_id=>@country.id)
    @place = Factory.create(:place,:address_id=>@address.id)
    @business=@place.business
    @program=Factory.create(:program,:program_type=>Factory.create(:program_type,:name=>"Marketing"),:business_id=>@business.id)
    @campaign=Factory.create(:campaign,:program_id=>@program.id)
    @engagement=Factory.create(:engagement,:campaign_id=>@campaign.id)
    @reward=Factory.create(:reward,:campaign_id=>@campaign.id)
  end
  test "should get index" do
    get :index,{:business_id=>@business.id}
    assert_response :success
    assert_not_nil assigns(:campaigns)
    assert_equal  assigns(:campaigns).size,1
  end

  test "should get new" do
    get :new,{:business_id=>@business.id}
    assert_response :success
    assert_not_nil assigns(:campaign)
    assert_not_nil assigns(:reward)
  end
    
  test "should create campaign" do
    assert_difference('Campaign.count') do
      @campaign=Factory.build(:campaign,:program_id=>@program.id)      
      @engagement=@campaign.engagements.build(:engagement_type_id=>Factory.create(:engagement_type,:name=>"Buy a product/service",:has_item=>true).id,:amount=>1)
      @reward=@campaign.rewards.build(:name=>"Coffee Drink",:needed_amount=>10)
      params=@campaign.attributes
      params["item_name"]="Coffee"
      params["engagements_attributes"]={}
      params["rewards_attributes"]={}
      params["engagements_attributes"]["0"]=@engagement.attributes
      params["rewards_attributes"]["0"]=@reward.attributes
      post :create, {:business_id=>@business.id,:campaign => params}
    end   
    assert_redirected_to business_campaign_path(@business,assigns(:campaign))
  end
end