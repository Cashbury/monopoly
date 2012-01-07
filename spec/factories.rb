Factory.define :measurement_type do |mt|
  mt.sequence(:name) {|n| "MeasurementType#{n}" }
end

Factory.define :account_holder do |acch|
  acch.model_type "User"
  acch.model_id  1
end

Factory.define :program_type do |pt|
  pt.sequence(:name) {|n| "Type#{n}" }
end

Factory.define :brand do |b|
  b.sequence(:name) {|n| "brand#{n}" }
  b.description "A kind of a business"
end

Factory.define :business do |b|
  b.sequence(:name) {|n| "business#{n}" }
  b.description "A kind of a business"
  b.brand Factory.create(:brand)
  b.tag_list ["business_tag"]
end

Factory.define :program do |p|
  p.program_type_id {Factory(:program_type).id}
  p.business_id {Factory(:business).id}
end

Factory.define :campaign do |c|
  c.sequence(:name) {|n| "campaign#{n}" }
  c.start_date Date.today
  c.end_date Date.today+12
  c.initial_amount 10
  c.initial_biz_amount 1000
  c.program_id {Factory(:program).id}
  c.measurement_type_id {Factory(:measurement_type).id}
end

Factory.define :account do |acc|
  acc.account_holder_id {Factory(:account_holder).id}
  acc.campaign_id {Factory(:campaign).id}
  acc.measurement_type_id {Factory(:measurement_type).id}
  acc.amount 100
  acc.is_money false
end

Factory.define :transaction_type do |transaction_type|
  transaction_type.name "Loyalty Collect"
  transaction_type.fee_amount 0.0
  transaction_type.fee_percentage 0.0
end

Factory.define :action do |action|
  action.name "Engagement"
  action.transaction_type_id {Factory(:transaction_type).id}
end

Factory.define :engagement_type do |eng_type|
  eng_type.name  "spend"
end

Factory.define :engagement do |eng|
  eng.sequence(:name) {|n| "Engagement#{n}"}
  eng.description "Buy 10 cups of coffee, get one free"
  eng.amount  1
  eng.campaign_id {Factory(:campaign).id}
  eng.engagement_type_id {Factory(:engagement_type).id}
end

Factory.define :qr_code do |qrcode|
  qrcode.hash_code ActiveSupport::SecureRandom.hex(10) 
  qrcode.code_type 0
  qrcode.status    true
  qrcode.associatable_id  {Factory(:engagement).id}
  qrcode.associatable_type "Engagement"
end

Factory.define :address do |addr|
  addr.street_address "street address"
  addr.neighborhood "neighborhood"
  addr.country_id {Factory(:country).id}
  addr.city_id {Factory(:city).id}
  addr.zipcode "21111"
end

Factory.define :city do |city|
  city.name "city name"
end

Factory.define :country do |country|
  country.name "country name"
  country.abbr "CN"
end

Factory.define :amenity do |a|
  a.name "swimming pool"
end

Factory.define :category do |category|
  category.name "Coffee Shops"
  category.description "Those Coffee shops that serves drinks"
end

Factory.define :place do |p|
  p.sequence(:name) {|n| "place#{n}" }
  p.business Factory.create(:business)
  p.lat 22.2222
  p.long 33.3333
end

Factory.define :reward do |reward|
  reward.name "A cup of coffee"
  reward.heading1 "A short desc"
  reward.heading2 "Buy 10 cups of coffee and get one free"
  reward.needed_amount 10
  reward.campaign_id {Factory(:campaign).id}
  reward.legal_term "A Legal Term"
  reward.max_claim 10
  reward.max_claim_per_user 2
end

Factory.define :user do |u|
  u.sequence(:email) {|n| "user#{n}@example.com" }
  u.password "123456"
  u.encrypted_password "$2a$10$NylIHtqSuhIeo5c8MWJ77efEunxf1usbgN./LqAZ5rHfRxaEp1ag2"
  u.password_salt "$2a$10$NylIHtqSuhIeo5c8MWJ77e"
  u.first_name "Basayel"
  u.last_name "Said"
end
