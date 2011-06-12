require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  context "testing places" do
    setup do
      country=Factory.create(:country,:name=>"Egypt",:abbr=>"EG")
      city=Factory.create(:city,:name=>"Alexandria",:lat=>"31.2135",:lng=>"29.9443",:country=>country)
      address=Factory.create(:address,:city_id=>city.id,:country_id=>country.id)
      @place=Factory.create(:place,:address_id=>address.id)
    end
    
    should "add place name into place tag list" do
      assert Place.find(@place.id).tag_list.include?(@place.name)
    end
  end
end
