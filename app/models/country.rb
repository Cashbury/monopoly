class Country < ActiveRecord::Base
  has_many :cities
  has_many :addresses
  has_one  :address_profile
end
