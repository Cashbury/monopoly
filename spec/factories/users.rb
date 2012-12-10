FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    first_name Faker::Name.name
    last_name Faker::Name.name
    password "123456"
    encrypted_password "$2a$10$742qdhkJZ2xxqKYhjb4NA.iOC6zLrWjKQciEqZXnV6H.kXd.zJm1C" #123456
    is_terms_agreed true
    dob "1987-08-29"
    gender "female"
  end
end