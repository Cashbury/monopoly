require 'test_helper'

class AmenityTest < ActiveSupport::TestCase
  # Replace this with your real tests
  context "testing amenities" do
    setup do
    	@place=Factory.create(:place)
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
