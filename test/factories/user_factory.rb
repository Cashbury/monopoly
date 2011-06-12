Factory.define :user do |u|
  u.sequence(:email) {|n| "user#{n}@example.com" }
  u.password "123456"
  u.encrypted_password "$2a$10$NylIHtqSuhIeo5c8MWJ77efEunxf1usbgN./LqAZ5rHfRxaEp1ag2"
  u.password_salt "$2a$10$NylIHtqSuhIeo5c8MWJ77e"
end