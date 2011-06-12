require 'test_helper'

class EngagementTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert !Engagement.new.valid?
  end
end
