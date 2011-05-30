require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def test_should_be_valid
    category=Category.new
    assert !category.valid?
    category=Category.new(:name=>"Coffee Shops")
    assert category.valid?
  end
end
