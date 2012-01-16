When /^I visit my transactions page$/ do
  path = "/users/#{@user.id}/transactions"
  visit "/users/#{@user.id}/transactions"
  current_path.should == path
end

Then /^I should see all my recent transactions$/ do
  page.should have_selector('table#transaction-list')
end
