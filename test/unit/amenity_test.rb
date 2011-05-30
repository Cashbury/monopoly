require 'test_helper'

class AmenityTest < ActiveSupport::TestCase
  # Replace this with your real tests
  context "testing amenities" do
    setup do
      country=Factory.create(:country,:name=>"Egypt",:abbr=>"EG")
      city=Factory.create(:city,:name=>"Alexandria",:lat=>"31.2135",:lng=>"29.9443",:country=>country)
      address=Factory.create(:address,:city_id=>city.id,:country_id=>country.id)
    	@place=Factory.create(:place,:address_id=>address.id)
      @amenity=Factory.create(:amenity)
      @place.amenities << @amenity
      @place.save
    end
    should "assign amenity successfully" do
			assert_equal Place.find(@place.id).amenities.count,1
			assert Place.find(@place.id).amenities.include?(@amenity)
	 end
  	
  	should "add amenity name into place tag list" do
			assert Place.find(@place.id).tag_list.include?(@amenity.name)
		end
	end
end
