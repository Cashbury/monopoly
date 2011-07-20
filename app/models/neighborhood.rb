class Neighborhood < ActiveRecord::Base
  attr_accessor :name, :approved, :city_id

  belongs_to :city

end
