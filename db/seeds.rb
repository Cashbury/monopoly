# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.create(:username => "user1", :name => "user", :password => "kazdoor", :password_confirmation => "kazdoor", :email => "user1@kazdoor.com")

c1 = Category.create(:name => "Food and Beverages", :description => "F&B business", :parent_id => nil)
c2 = Category.create(:name => "coffee", :description => "Coffee shops", :parent_id => c1.id)

b = Business.create(:name => "Gloria Jeans", :description => "Coffee Shop")
b.categories << c1
b.categories << c2

b.places.create(:name => "Hamra", :description => "Makdessi Street", :long => "33,896499", :lat => "35,480575")

campaign = Campaign.create("name" => "hamra stuff", :campaign_type => "engage")

engagement1 = campaign.engagements.create(:engagement_type => "stamp", :points => "20")

engagement1.rewards.create(:name => "Free cup of coffee")