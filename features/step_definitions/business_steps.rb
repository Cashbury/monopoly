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
