require 'spec_helper'

describe Account do

  it "should create account given valid attributes" do
    Factory.build(:account).should be_valid
  end

end
