Factory.define :campaign do |c|
  c.sequence(:name) {|n| "campaign#{n}" }
  c.start_date Date.today
  c.end_date Date.today+12
  c.initial_points 10
  c.program Factory.create(:program)
  c.measurement_type Factory.create(:measurement_type)
end