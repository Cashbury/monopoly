# These are defined in test/facotires.rb, but I don't know how they're used, so...
FactoryGirl.define do
  factory :cuke_user, :class => :user do
    email { Forgery(:internet).email_address }
    username { "#{Forgery(:name).first_name} #{Forgery(:name).last_name}".underscore }
    first_name { Forgery(:name).first_name }
    last_name { Forgery(:name).last_name }
    password 'password'
  end

  factory :cashbury_operator, :parent => :cuke_user do
    roles { [Role.where(:name => Role::AS[:operator]).first, Role.where(:name => Role::AS[:consumer]).first] }
  end
end
