require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  context "testing places" do
    setup do
      @place=Factory.create(:place)
    end
    
    should "add place name into place tag list" do
      assert_equal Place.find(@place.id).tag_list.include?(@place.name), true
    end
  end
end
