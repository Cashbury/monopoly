Factory.define :place do |p|
  p.sequence(:name) {|n| "place#{n}" }
  p.business Factory.create(:business)
  p.lat 22.2222
  p.long 33.3333
end