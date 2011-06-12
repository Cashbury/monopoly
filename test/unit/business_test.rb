require 'test_helper'

class BusinessTest < ActiveSupport::TestCase
  
  context "testing business" do
    setup do
      @business=Factory.create(:business)
    end
    should "add business name into business tag list" do
      assert Business.find(@business.id).tag_list.include?(@business.name)
    end
  end
end
