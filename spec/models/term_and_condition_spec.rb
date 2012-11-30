require 'spec_helper'

describe TermAndCondition do
  pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    @tc = TermAndCondition.new(:description => "")
  end

  it "should not be valid" do
    @tc.should_not be_valid
  end

  it "should set the error hash" do
    @tc.errors.should have(1).errors_on(:description)
  end 
end
