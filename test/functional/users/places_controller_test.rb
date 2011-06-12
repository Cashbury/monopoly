require 'test_helper'
class Users::PlacesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  context "test listing places API" do
    setup do
      @country1=Factory.create(:country,:name=>"Egypt",:abbr=>"EG")
      @city1=Factory.create(:city,:name=>"Alexandria",:lat=>"31.2135",:lng=>"29.9443",:country=>@country1)
      address1=Factory.create(:address,:city_id=>@city1.id,:country_id=>@country1.id)
      @country2=Factory.create(:country,:name=>"United States",:abbr=>"US")
      @city2=Factory.create(:city,:name=>"San Francisco",:lat=>"37.77493",:lng=>"-122.419416",:country=>@country2)
      address2=Factory.create(:address,:city_id=>@city2.id,:country_id=>@country2.id)
      @place1=Factory.create(:place,:lat=>"31.247755",:long=>"29.997804",:address_id=>address1.id)
      @place2=Factory.create(:place,:lat=>"31.248406",:long=>"29.997418",:address_id=>address1.id)
      @place3=Factory.create(:place,:lat=>"31.248291",:long=>"29.997493",:address_id=>address1.id)
      @place4=Factory.create(:place,:lat=>"37.77493",:long=>"-122.419416",:address_id=>address2.id)
      user=Factory.create(:user)
      user.confirm!
      sign_in user
    end
    context "testing listing nearby places given location" do
      setup do
        get :index, {:lat=>"31.247751",:long=>"29.997800",:format=>"xml"}
      end
      should "response successfully" do
        assert_response :success
        assert_equal assigns(:places).size, 3
        assert assigns(:places).include?(@place1)
        assert assigns(:places).include?(@place2)
        assert assigns(:places).include?(@place3)
        assert !assigns(:places).include?(@place4) #not nearby place
        assert assigns(:result)["is_my_city"]
        assert_equal assigns(:result)["city-id"],@city1.id
        assert_equal assigns(:result)["city-name"],@city1.name
      end
    end
    
    context "testing listing default San Francisco places without given location" do
      setup do
        get :index, {:format=>"xml"}
      end
      should "response successfully" do
        assert_response :success
        assert_equal assigns(:places).size, 1
        assert !assigns(:places).include?(@place1)
        assert !assigns(:places).include?(@place2)
        assert !assigns(:places).include?(@place3)
        assert assigns(:places).include?(@place4) #place at default city San Francisco
        assert !assigns(:result)["is_my_city"]
        assert_equal assigns(:result)["city-id"],@city2.id
        assert_equal assigns(:result)["city-name"],@city2.name
      end
    end
    
    context "testing listing places given Alexandria City id and my location" do
      setup do
        get :index, {:lat=>"31.247751",:long=>"29.997800",:format=>"xml",:city_id=>@city1.id}
      end
      should "response successfully" do
        assert_response :success
        assert_equal assigns(:places).size, 3
        assert assigns(:places).include?(@place1)
        assert assigns(:places).include?(@place2)
        assert assigns(:places).include?(@place3)
        assert !assigns(:places).include?(@place4) #not in alexandria
        assert assigns(:result)["is_my_city"]
        assert_equal assigns(:result)["city-id"],@city1.id
        assert_equal assigns(:result)["city-name"],@city1.name
      end
    end
    
    context "testing listing places given San Francisco City id and my location" do
      setup do
        get :index, {:lat=>"31.247751",:long=>"29.997800",:format=>"xml",:city_id=>@city2.id}
      end
      should "response successfully" do
        assert_response :success
        assert_equal assigns(:places).size, 1
        assert !assigns(:places).include?(@place1)
        assert !assigns(:places).include?(@place2)
        assert !assigns(:places).include?(@place3)
        assert assigns(:places).include?(@place4) #not in SF
        assert !assigns(:result)["is_my_city"]
        assert_equal assigns(:result)["city-id"],@city2.id
        assert_equal assigns(:result)["city-name"],@city2.name
      end
    end
  end
end