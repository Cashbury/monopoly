Given /^I am an Operator$/ do
  @user = FactoryGirl.create :cashbury_operator
  @user.confirm!
  @default_landing_page = "/businesses" # ugly hack yo, fix later
end

When /^I log into the site$/ do
  visit '/users/sign_in'
  within("#user_new") do
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => "password"
    click_button "Sign in"
  end
  current_path.should == @default_landing_page
end
