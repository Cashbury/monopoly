Then /^I should be able to make a new Money program$/ do
  click_link "New Program"
  within("#new_program") do
    select "Money", :from => "Program type"
    click_button "Create Program"
  end
  # Someone (or something) is cleaning the database too early, I guess.
  sleep(1)
  @current_business.reload
  @current_business.programs.should have(1).items
  @current_business.programs.last.program_type.should == ProgramType["Money"]
end

Then /^I should not be able to make a new Money program$/ do
  last_url = current_path
  visit new_business_program_path(@current_business)
  within "#new_program" do
    page.should_not have_select("Program type", :options => ["Money"])
  end
end

Then /^I should not be able to change the Money program into a Marketing program$/ do
  visit business_programs_path(@current_business)
  page.should_not have_link "Edit"

  visit business_program_path(@current_business, @current_business.money_program)
  page.should_not have_link "Edit"
end

Then /^I should be able to set the cashbox account load limit to "(\d+)"$/ do |limit|
  visit edit_business_cashbox_path(@current_business)
  within 'form.edit_account_option' do
    fill_in "Maximum daily load limit", :with => limit
    click_button "Update cashbox settings"
  end
  sleep(1)
  account_option = @current_business.cashbox.account_option.reload
  account_option.max_daily_load_limit.should == limit.to_i
end

Then /^I should be able to set the cashbox account spend limit to "(\d+)"$/ do |limit|
  visit edit_business_cashbox_path(@current_business)
  within 'form.edit_account_option' do
    fill_in "Maximum daily spending limit", :with => limit
    click_button "Update cashbox settings"
  end
  sleep(1)
  account_option = @current_business.cashbox.account_option.reload
  account_option.max_daily_spend_limit.should == limit.to_i
end
