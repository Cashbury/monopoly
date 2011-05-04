Factory.define :campaign do |c|
  c.sequence(:name) {|n| "campaign#{n}" }
  c.start_date Date.today
  c.end_date Date.today+12
  c.initial_amount 10
  c.initial_biz_amount 1000
  c.program_id {Factory(:program).id}
  c.measurement_type_id {Factory(:measurement_type).id}
  c.max_claim 10
  c.max_claim_per_user 2
end