Given /^I have saved "(\d+)" dollars by using cashburies at various businesses$/ do |amount|
	half = amount.to_i / 2
	2.times { 
		biz = Factory(:business)
		biz.create_money_program!		
		@user.enroll(biz.money_program)

		@user.cashbury_account_for(biz).load(half)
		@user.cash_account_for(biz).spend(half)
	}
end

Given /^I have saved "(\d+)" dollars by using cashburies at "([^"]*)"$/ do |amount, business_name|
	biz = Business.find_by_name business_name
	biz.should_not be_nil

	biz.create_money_program!
	@user.enroll(biz.money_program)

	@user.cashbury_account_for(biz).load(amount.to_i)
	@user.cash_account_for(biz).spend(amount.to_i)
end