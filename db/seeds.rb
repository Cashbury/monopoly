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
    if record.chomp.include?(":")
      country_attrs=record.split(":")
      country=Country.find_or_create_by_name(:name=>country_attrs[0].lstrip.rstrip,:abbr=>country_attrs[1].lstrip.rstrip)
      next
    end
    city_name=record
    City.find_or_create_by_name(:name=>city_name.lstrip.rstrip,:country_id=>country.id)
  end
end
puts "Creating system program types"
ProgramType.find_or_create_by_name(:name=>"Marketing")
ProgramType.find_or_create_by_name(:name=>"Money")
puts "Creating system engagement types"
EngagementType.delete_all(:name=>"Check-IN")
EngagementType.find_or_create_by_name(:name=>"Visit/Check-IN", :is_visit=>true)
EngagementType.find_or_create_by_name(:name=>"Buy a product/service",:has_item=>true)
EngagementType.find_or_create_by_name(:name=>"Question")
EngagementType.find_or_create_by_name(:name=>"Spend")
puts "Creating system measurement types"
MeasurementType.find_or_create_by_name(:name=>"Money")
MeasurementType.find_or_create_by_name(:name=>"Points")
puts "Creatring system targets"
Target.find_or_create_by_name(:name=>"new_comers")
Target.find_or_create_by_name(:name=>"returning_comers")
