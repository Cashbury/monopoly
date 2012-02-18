Given /^I am an Operator$/ do
  @user = FactoryGirl.create :cashbury_operator
  @user.confirm!
  @default_landing_page = "/businesses" # ugly hack yo, fix later
end

Given /^I am a Cashier at "([^"]*)"$/ do |business|
  @cashier = FactoryGirl.create :cashier
  @cashier.confirm!
  e = @cashier.employees.first
  e.business = Business.find_by_name business
  e.save
  @cashier.save
end


Given /^I am a Cashier at "([^"]*)" with the auth token "([^"]*)"$/ do |business, auth_token|
  @cashier = FactoryGirl.create :cashier, :authentication_token => auth_token
  @cashier.confirm!
  e = @cashier.employees.first
  e.business = Business.find_by_name business
  e.save
  @cashier.save
end

Given /^I am a Consumer$/ do
  @user = FactoryGirl.create :consumer
  @user.confirm!
end

Given /^I am a Consumer with the auth token "([^"]*)"$/ do |auth_token|
  @user = FactoryGirl.create :consumer, :authentication_token => auth_token
  @user.confirm!
end

Given /^"([^"]*)" is a consumer$/ do |email|
  @consumer = FactoryGirl.create :consumer, :email => email
end

Given /^"([^"]*)" is the current consumer$/ do |email|
  @consumer = FactoryGirl.create :consumer, :email => email
  qr_code = QrCode.create
  qr_code.hash_code ="123456"
  qr_code.status = true
  qr_code.save
  @consumer.qr_code = qr_code
  account_holder = AccountHolder.create
  @consumer.account_holder = account_holder
end

Given /^"([^"]*)" is the current consumer and has an auth token "([^"]*)"$/ do |email, auth_token|
  @consumer = FactoryGirl.create :consumer, :email => email, :authentication_token => auth_token
  qr_code = QrCode.create
  qr_code.hash_code ="123456"
  qr_code.status = true
  qr_code.save
  @consumer.qr_code = qr_code
  account_holder = AccountHolder.create
  @consumer.account_holder = account_holder
end


Given /^the current consumer has a cash account at the current business with a balance of (\d+)$/ do |balance|
  @consumer.enroll(@current_business.money_program)
  account = @consumer.cash_account_for(@current_business)
  employee= @cashier.employees.where(:role_id=>Role.find_by_name(Role::AS[:cashier]).id).first   
  account.load(balance.to_i, @cashier)
end


When /^I log into the site$/ do
  visit '/users/sign_in'
  within("#user_new") do
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => "password"
    click_button "Sign in"
  end
  current_path.should_not == '/users/sign_in'
end
