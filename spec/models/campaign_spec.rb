require 'spec_helper'

describe Campaign do
  it "should be able to create campaigns with only valid information " do
    c = Campaign.new
    c.should_not be_valid
    end
end