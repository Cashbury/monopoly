require 'test_helper'

class BusinessTest < ActiveSupport::TestCase
  
  context "testing business" do
    setup do
      @business=Factory.create(:business)
    end
    should "add business name into business tag list" do
      assert_equal @business.tag_list.include?(@business.name), true
    end
  end
end
