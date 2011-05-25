Factory.define :engagement do |eng|
  eng.sequence(:name) {|n| "Engagement#{n}"}
  eng.description "Buy 10 cups of coffee, get one free"
  eng.amount  1
  eng.campaign_id {Factory(:campaign).id}
  eng.engagement_type_id {Factory(:engagement_type).id}
end