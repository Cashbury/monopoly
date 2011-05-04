Factory.define :business do |b|
  b.sequence(:name) {|n| "business#{n}" }
  b.description "A kind of a business"
  b.brand Factory.create(:brand)
  b.tag_list ["business_tag"]
end