Factory.define :brand do |b|
  b.sequence(:name) {|n| "brand#{n}" }
  b.description "A kind of a business"
end