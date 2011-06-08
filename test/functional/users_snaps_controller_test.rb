require 'test_helper'

class UsersSnapsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @admin=Factory.create(:user,:admin=>true)
    @admin.confirm!
    sign_in @admin
    @user1=Factory.create(:user)
    @user2=Factory.create(:user)
    country=Factory.create(:country,:name=>"Egypt",:abbr=>"EG")
    city=Factory.create(:city,:name=>"Alexandria",:lat=>"31.2135",:lng=>"29.9443",:country=>country)
    address=Factory.create(:address,:city_id=>city.id,:country_id=>country.id)
    @place=Factory.create(:place,:address_id=>address.id)
    program=Factory.create(:program,:business_id=>@place.business.id)
    @campaign=Factory.create(:campaign,:program_id=>program.id,:initial_amount=>10)
    @engagement=Factory.create(:engagement,:campaign_id=>@campaign.id,:amount=>5)
    @qr_code=Factory.create(:qr_code,:associatable_id=>@engagement.id)
    @action=Factory.create(:action)
    @places=[];@places << @place
    @user1.auto_enroll_at(@places)
    @user2.auto_enroll_at(@places)
    @user1.snapped_qrcode(@qr_code,@engagement,@place.id,@place.lat,@place.long)
    @user2.snapped_qrcode(@qr_code,@engagement,@place.id,@place.lat,@place.long)
  end
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:results)
    assert !assigns(:results).empty?
    assert_equal assigns(:results).size,2
  end
end
