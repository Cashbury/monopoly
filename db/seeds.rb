# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
puts 'Create an admin account'
User.create(:username => "admin", :name => "Admin", :password => "c@$hbury", :password_confirmation => "c@$hbury", :email => "hb@cashbury.com", :admin=>true)
transaction_type=TransactionType.find_or_create_by_name(:name=>"Loyalty Collect", :fee_amount=>0.0, :fee_percentage=>0.0)
Action.find_or_create_by_name([{:name=>"Engagement", :transaction_type_id=>transaction_type.id},{:name=>"Redeem",:transaction_type_id=>transaction_type.id}])

puts 'Creating countries and cities from contries_cities,txt ...'
open(Rails.root.join('db').join('countries_cities.txt')) do |records|
  country=nil
  records.read.each_line do |record|
    if record.chomp.end_with?(":")
      country_name=record.split(":")
      country=Country.find_or_create_by_name(:name=>country_name[0].lstrip.rstrip)
      next
    end
    city_name=record
    City.find_or_create_by_name(:name=>city_name.lstrip.rstrip,:country_id=>country.id)
  end
end

puts "Creating system engagement types"
EngagementType.create([{:name=>"Check-IN"},{:name=>"Buy a product/service",:has_item=>true},{:name=>"Question"}, {:name=>"Spend"}])
puts "Creating system measurement types"
MeasurementType.create([{:name=>"Money"},{:name=>"Points"}])
