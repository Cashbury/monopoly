require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Reward.new.valid?
  end
end
