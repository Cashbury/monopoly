Factory.sequence :email do |n|
  "test#{n}.#{rand(99999)}@testex.com"
end

Factory.define :user do |user|
  user.first_name "Factory"
  user.last_name "Test user"
  user.email { Factory.next(:email) }
  user.password "superpass"
  user.password_confirmation "superpass"
end
