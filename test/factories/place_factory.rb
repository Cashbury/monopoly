FactoryGirl.define do
  factory :place do
    sequence(:name) {|n| "place#{n}" }

    lat 22.2222
    long 33.3333

    business
    address
  end
end
