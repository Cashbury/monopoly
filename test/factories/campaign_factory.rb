Factory.define :campaign do |c|
  c.sequence(:name) {|n| "campaign#{n}" }
  c.start_date Date.today
  c.end_date Date.today+12
  c.initial_points 10
  c.program_id {Factory(:program).id}
  c.measurement_type_id {Factory(:measurement_type).id}
end