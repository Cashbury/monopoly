require 'spec_helper'

describe Program do
  context "Money Programs" do
    let(:business) { Factory(:business) }
    it "#create_money_program! should create a money program" do
      business.should_not have_money_program
      business.create_money_program!
      business.should have_money_program
    end

    it "should create a cashbox account for a business" do
      business.cashbox.should be_nil
      business.create_money_program!
      business.cashbox.should_not be_nil
    end

    it "should create a reserve account for a business" do
      business.create_money_program!
      business.reserve_account.should_not be_nil
    end

    it "should create a cashburies account for a business" do
      business.create_money_program!
      business.cashbury_account.should_not be_nil
    end

  end
end
