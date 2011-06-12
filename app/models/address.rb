class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :country
  has_many :places
  validates_presence_of :city_id, :country_id
  attr_accessible :zipcode, :city_id, :country_id, :neighborhood, :street_address
end
