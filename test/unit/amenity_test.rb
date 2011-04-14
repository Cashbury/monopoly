require 'test_helper'

class AmenityTest < ActiveSupport::TestCase
  # Replace this with your real tests
  setup do
  	@place=Factory.create(:place)
    @amenity=Factory.create(:amenity)
    @place.amenities << @amenity
    @place.save
  end
  should "assign amenity successfully" do
  	assert_equal Place.find(@place.id).amenities.count,1
  	assert Place.find(@place.id).amenities.include(@amenity)
	end
end
