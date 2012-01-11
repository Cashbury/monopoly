require 'spec_helper'

describe Account do
  let(:business) { Factory(:business) }
  it "#cashout should transfer all the money in the user's cashbox account to the business reserve account" do
    user = Factory(:consumer)
    business.create_money_program!
    user.enroll(business.money_program)

    account = user.cash_account_for(business)
    account.update_attributes :amount => 150

    account.cashout
    account.amount.should == 0

    business.reserve_account.amount.should == 150
  end

end
