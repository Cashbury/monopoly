When /^I visit the program page for "([^"]*)"$/ do |business_name|
  @current_business = Business.where(:name => business_name).first
  @current_business.should_not be_nil
  visit business_programs_path(@current_business)
end

Then /^the business should have a cashbox account$/ do
  @current_business.cashbox.should_not be_nil
end

Given /^the current business has a Money program$/ do
  @current_business.programs << Program.create(:program_type => ProgramType["Money"])
end

Given /^"([^"]*)" is the current business$/ do |business_name|
  @current_business = Business.where(:name => business_name).first
  @current_business.should_not be_nil
end

Given /^"([^"]*)" has a Money program$/ do |business_name|
  @current_business = Business.where(:name => business_name).first
  @current_business.should_not be_nil
  @current_business.programs << Program.create(:program_type => ProgramType["Money"])
end

When /^I visit the user page for "([^"]*)"$/ do |email|
  user = User.find_by_email email
  user.should_not be_nil
  visit users_management_path(user)
  current_path.should == users_management_path(user)
end

Then /^I should be able to enroll "([^"]*)" into the Money program for "([^"]*)"$/ do |email, business_name|
  user = User.find_by_email email
  user.should_not be_nil

  business = Business.find_by_name business_name
  business.should_not be_nil

  within_fieldset "Money Program Enrollment" do
    select business.name, :from => "business_id"
    click_button "Enroll"
  end
end
Then /^"([^"]*)" should be enrolled in the Money program for "([^"]*)"$/ do |email, business_name|
  user = User.find_by_email email
  business = Business.find_by_name business_name

  money_program = user.money_program_for(business)
  money_program.should == business.money_program
end

Then /^"([^"]*)" should have a cash account with "([^"]*)"$/ do |email, business_name|
  user = User.find_by_email email
  business = Business.find_by_name business_name

  cash_account = user.cash_account_for(business)
  cash_account.should_not be_nil
end
