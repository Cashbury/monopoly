Factory.define :reward do |reward|
  reward.name "A cup of coffee"
  reward.description "Buy 10 cups of coffee and get one free"
  reward.needed_amount 10
  reward.campaign_id {Factory(:campaign).id}
  reward.legal_term "A Legal Term"
  reward.max_claim 10
  reward.max_claim_per_user 2
end