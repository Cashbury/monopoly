Given /^I am an Operator$/ do
  @user = FactoryGirl.create :cashbury_operator
  @user.confirm!
  @default_landing_page = "/businesses" # ugly hack yo, fix later
end

Given /^I am a Cashier at "([^"]*)"$/ do |business|
  @user = FactoryGirl.create :cashier
  @user.confirm!
  e = @user.employees.first
  e.business = Business.find_by_name business
  e.save
  @user.save
end

Given /^"([^"]*)" is a consumer$/ do |email|
  @consumer = FactoryGirl.create :consumer, :email => email
  qr_code = QrCode.create
  qr_code.hash_code ="123456"
  qr_code.status = true
  qr_code.save
  @consumer.qr_code = qr_code
  account_holder = AccountHolder.create
  @consumer.account_holder = account_holder
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
