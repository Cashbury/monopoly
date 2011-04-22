class Address < ActiveRecord::Base
  belongs_to :place
  attr_accessible :zipcode, :city, :country, :neighborhood, :street_address
end
