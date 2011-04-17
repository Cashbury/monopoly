Factory.define :engagement do |eng|
  eng.sequence(:name) {|n| "Engagement#{n}"}
  eng.description "Buy 10 cups of coffee, get one free"
  eng.state   true
  eng.amount  1
  eng.campaign Factory.create(:campaign)
  eng.engagement_type_id Factory.create(:engagement_type)
end