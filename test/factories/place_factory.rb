Factory.define :place do |p|
  p.sequence(:name) {|n| "place#{n}" }
  p.business Factory.create(:business)
end