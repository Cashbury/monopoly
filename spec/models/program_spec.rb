require 'spec_helper'

describe Program do
  context "Money Programs" do
    let(:business) { Factory(:business) }
    it "should create a cashbox account for a business" do
      business.should_not have_money_program
      business.cashbox.should be_nil

      business.create_money_program!

      business.should have_money_program
      business.cashbox.should_not be_nil
    end
    pending "should create a reserve account for a business"
  end
end
