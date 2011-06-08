require 'test_helper'

class Businesses::PlacesControllerTest < ActionController::TestCase
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
  end
  test "should get index" do
    get :index,{:business_id=>@business.id}
    assert_response :success
    assert_not_nil assigns(:places)
  end

  test "should get new" do
    get :new,{:business_id=>@business.id}
    assert_response :success
  end

  test "should create place" do
    assert_difference('Place.count') do
      place=Factory.build(:place)
      params=place.attributes
      params["address_attributes"]=Factory.build(:address).attributes
      post :create, {:business_id=>@business.id,:place => params}
    end

    assert_redirected_to business_place_path(@business,assigns(:place))
  end

  test "should show place" do
    get :show, {:business_id=>@business.id,:id => @place.to_param}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:business_id=>@business.id,:id => @place.to_param}
    assert_response :success
  end

  test "should update place" do
    put :update, {:business_id=>@business.id,:id => @place.to_param, :place => @place.attributes}
    assert_redirected_to business_place_path(@business,assigns(:place))
  end

  test "should destroy place" do
    assert_difference('Place.count', -1) do
      delete :destroy, {:business_id=>@business.id,:id => @place.to_param}
    end

    assert_redirected_to business_places_path(@business)
  end
end