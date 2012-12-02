puts 'creating roles'
Role::AS.values.each do |name|
  Role.find_or_create_by_name(:name => name )
end



unless User.where(:email => 'revolteur@gmail.com').exists?
  puts 'Create an admin account'
  admin_user = User.new(:username => "admin", :name => "Admin", :password => "Monopoly", :password_confirmation => "Monopoly", :email => "revolteur@gmail.com", :admin=>true, :confirmed_at=>Date.today, is_terms_agreed: true)
  admin_user.roles << Role.find_by_name(Role::AS[:admin])
  admin_user.save!

  puts 'confirming admin user has signed up'
  admin_user.confirm!
  admin_user.save!
end
unless User.where(:email => "hb@cashbury.com").exists?
  puts 'Creating another admin account'
  new_admin_user = User.new(:username => "admin", :name => "Admin2", :password => "c@$hbury", :password_confirmation => "c@$hbury", :email => "hb@cashbury.com", :admin=>true, :confirmed_at=>Date.today, is_terms_agreed: true)
  new_admin_user.roles << Role.find_by_name(Role::AS[:admin])
  new_admin_user.save!

  puts 'confirming new admin has signed up'
  new_admin_user.confirm!
  new_admin_user.save!
end

puts "Create transaction types and actions"

# { TransactionType => [ACTIONS] }
transaction_types = {
  "Loyalty Collect" => %w( Engagement Redeem ),
  "Accounts Transfer" => %w( Withdraw Deposit ),
  "Cashout" => %w( Cashout ),
  "Load" => %w( Load ),
  "Spend" => %w( Spend ),
  "Tip"  => %w( Tip ),
  "Gift" => %w( Gift )
}
actions = %w( Refund )

transaction_types.keys.each do |tt_name|
  tt = TransactionType.find_or_create_by_name(name: tt_name, fee_amount: 0.0, fee_percentage: 0.0)
  transaction_types[tt_name].each do |action_name|
    Action.find_or_create_by_name(name: action_name, transaction_type_id: tt.id)
  end
end

actions.each { |action_name| Action.find_or_create_by_name action_name }

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

open(Rails.root.join('db').join('countries_dialcodes.txt')) do |records|
  records.read.each_line do |record|
    details = record.strip.split(",")
    country_name = details.first.strip
    dialcode = details.last.strip
    if (c = Country.where("name LIKE '#{country_name}%'").first).present?
      c.update_attribute(:phone_country_code, "+#{dialcode}")
    end
  end
end

#######################
puts <<FOOTER

Seeding complete! Several tables were seeded:
  Important Models:
    - Role
    - TransactionType
    - Action
    - City
    - Country
    - Admin
    - ProgramType
    - EngagementType
    - MeasurementType
    - LoginMethod
    - LegalType

FOOTER