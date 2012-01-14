require 'spec_helper'

describe Account do
  let(:business) { Factory(:business) }
  let(:user)     { Factory(:consumer) }

  context "Money Program" do
    before(:each) do
      business.create_money_program!
      user.enroll(business.money_program)
    end

    it "#cashout should transfer all the money in the user's cashbox account to the business reserve account" do
      account = user.cash_account_for(business)
      account.update_attributes :amount => 150

      account.cashout
      account.amount.should == 0

      business.reserve_account.amount.should == 150
    end

    it "#load should transfer money from a business reserve account to a user's cashbox account" do
      account = user.cash_account_for(business)

      account.load(50)
      account.amount.should == 50
      business.reserve_account.amount.should == -50
    end

    it "#load should transfer cashburies from a business cashbury account to a user's cashbury account" do
      account = user.cashbury_account_for(business)

      account.load(50)
      account.amount.should == 50
      business.cashbury_account.amount.should == -50
    end

    it "#spend should transfer money from a user's cashbox account to a business reserve account" do
      account = user.cash_account_for(business)

      account.spend(50)
      account.amount.should == -50
      business.reserve_account.amount.should == 50
    end

    it "#spend should transfer cashburies from a user's cashbury account to a business cashbury account" do
      account = user.cashbury_account_for(business)

      account.spend(50)
      account.amount.should == -50
      business.cashbury_account.amount.should == 50
    end

    it "#spend should debit cashburies from a user's account before debiting a user's cash account" do
      cashbury_account = user.cashbury_account_for(business)
      cash_account = user.cash_account_for(business)

      cash_account.update_attributes :amount => 20
      cashbury_account.update_attributes :amount => 15

      cash_account.spend(10)

      cashbury_account.reload
      cashbury_account.amount.should == 5

      cash_account.reload
      cash_account.amount.should == 20

      # Cashbury: 5
      # Cash: 20

      cash_account.spend(15)

      cashbury_account.reload
      cashbury_account.amount.should == 0

      cash_account.reload
      cash_account.amount.should == 10
    end

    it "#tip should transfer money from a user's cashbox account to a business cashbox account" do
      account = user.cash_account_for(business)

      account.tip(50)

      business.cashbox.amount.should == 50
    end

    it "#group_transactions should group transactions together" do
      account = user.cash_account_for(business)

      tx_grp = Account.group_transactions do
        account.load(50)
        account.spend(50)
      end

      tx_grp.transactions.should have(2).items
    end



  end
end
