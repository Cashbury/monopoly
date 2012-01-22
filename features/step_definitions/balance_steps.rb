Given /^I have "(\d+)" cashburies at "([^"]*)"$/ do |amount, business_name|
  business = Business.find_by_name(business_name)
  business.should_not be_nil

  @user.cashbury_account_for(business).update_attributes :amount => amount
end

Given /^I have "(\d+)" dollars at "([^"]*)"$/ do |amount, business_name|
  business = Business.find_by_name(business_name)
  business.should_not be_nil

  @user.cash_account_for(business).update_attributes :amount => amount
end
