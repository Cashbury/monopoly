class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :country
  attr_accessible :zipcode, :city_id, :country_id, :neighborhood, :street_address
end
