# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
puts 'Create an admin account'
User.create(:username => "admin", :name => "Admin", :password => "c@$hbury", :password_confirmation => "c@$hbury", :email => "hb@cashbury.com", :admin=>true, :confirmed_at=>Date.today)
puts "Create transaction types and actions"
transaction_type=TransactionType.find_or_create_by_name(:name=>"Loyalty Collect", :fee_amount=>0.0, :fee_percentage=>0.0)
%w( Engagement Redeem ).each do |name|
  Action.find_or_create_by_name(:name=>name, :transaction_type_id=>transaction_type.try(:id))
end

transaction_type=TransactionType.find_or_create_by_name(:name=>"Accounts Transfer", :fee_amount=>0.0, :fee_percentage=>0.0)
%w( Withdraw Deposit ).each do |name|
  Action.find_or_create_by_name(:name=>name, :transaction_type_id=>transaction_type.try(:id))
end

puts 'Creating countries and cities from contries_cities,txt ...'
open(Rails.root.join('db').join('countries_cities.txt')) do |records|
  country=nil
  records.read.each_line do |record|
    if record.chomp.include?(":")
      country_attrs=record.split(":")
      country=Country.find_or_create_by_name(:name=>country_attrs[0].lstrip.rstrip,:abbr=>country_attrs[1].lstrip.rstrip)
      next
    end
    city_attrs=record.split(",")
    City.find_or_create_by_name(:name=>city_attrs[0].lstrip.rstrip,:country_id=>country.id,:lat=>city_attrs[1],:lng=>city_attrs[2])
  end
end
puts "Creating system program types"
ProgramType.find_or_create_by_name(:name=>"Marketing")
ProgramType.find_or_create_by_name(:name=>"Money")
puts "Creating system engagement types"
EngagementType.find_or_create_by_name(:name=>"visit", :eng_type=>EngagementType::ENG_TYPE[:visit])
EngagementType.find_or_create_by_name(:name=>"buy",:eng_type=>EngagementType::ENG_TYPE[:buy])
EngagementType.find_or_create_by_name(:name=>"spend",:eng_type=>EngagementType::ENG_TYPE[:spend])
EngagementType.find_or_create_by_name(:name=>"share", :eng_type=>EngagementType::ENG_TYPE[:share])
puts "Creating system measurement types"
MeasurementType.find_or_create_by_name(:name=>"Money")
MeasurementType.find_or_create_by_name(:name=>"Points")
puts "Creatring system targets"
Target.find_or_create_by_name(:name=>"new_comers")
Target.find_or_create_by_name(:name=>"returning_comers")
puts "Create Default user roles here"
#check this is working or not
#%w( admin owner operator principal accountant manager branch_manager cashier consumer).each do |name|
Role::AS.values.each do |name|
  Role.find_or_create_by_name(:name => name )
end
puts "Creating system login methods"
%w(facebook email_and_password phone_and_password qrcode ).each do |name|
  LoginMethod.find_or_create_by_name(:name => name )
end
puts "Creating system legal ids types"
%w(social_number passport_number).each do |name|
  LegalType.find_or_create_by_name(:name => name )
end
puts "Seeding DB with currencies"
#open(Rails.root.join('db').join('currencies.txt')) do |records|
#  records.read.each_line do |record|
#    currency_details=record.split(",")    
#  end
#end
ISO4217::Currency.load_file(Rails.root.join('db').join('currencies.yml'))
