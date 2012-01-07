require 'spec_helper'

describe Campaign do

  it "should create campaign given valid attributes" do
    Factory.build(:campaign).should be_valid
  end

end
