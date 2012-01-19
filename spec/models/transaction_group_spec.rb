require 'spec_helper'

describe TransactionGroup do
  it "generates a unique, friendly id" do
    tx = TransactionGroup.new
    tx.save!

    tx.friendly_id.should be_present
  end

  it "should void all transactions in its group" do
    business = Factory(:business)
    user = Factory(:consumer)
    op  = Factory(:cashbury_operator)

    business.create_money_program!
    user.enroll(business.money_program)

    account = user.cash_account_for(business)
    tx_grp = Account.group_transactions do
      account.load(50)
      account.spend(50)
    end

    tx_grp.transactions.should have(2).items

    tx_grp.void!(op)

    tx_grp.transactions.reload
    tx_grp.transactions.each do |tx|
      tx.state.should == Transaction::States::VOID
    end

  end
end
