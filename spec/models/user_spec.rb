require 'spec_helper'

describe User do
  let(:subject) { Factory(:consumer) }
  let(:business) { Factory(:business) }

  context "#enroll" do
    before do
      business.create_money_program!
    end

    it "should setup the user with a cash account" do
      subject.enroll(business.money_program)

      subject.cash_account_for(business).should_not be_nil
    end

    it "should setup the user with a cashbury account" do
      subject.enroll(business.money_program)

      subject.cashbury_account_for(business).should_not be_nil
    end

  end


  it "should #auto_enroll_at a business with a money program" do
    place = Factory(:place, :business => business)
    business.create_money_program!

    subject.auto_enroll_at([place])
    subject.programs.should include(business.money_program)
  end

  it "#cashout_at should cash out a user at a business" do
    business.create_money_program!
    subject.enroll(business.money_program)

    account = subject.cash_account_for(business)

    account.update_attributes :amount => 150

    subject.cashout_at(business)

    account.reload
    account.amount.should == 0
  end
end
