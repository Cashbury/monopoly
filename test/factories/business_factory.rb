Factory.define :business do |b|
  b.sequence(:name) {|n| "business#{n}" }
  b.description "A kind of a business"
end