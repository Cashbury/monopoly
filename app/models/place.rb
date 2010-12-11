class Place < ActiveRecord::Base
  belongs_to :business
  attr_accessible :name, :long, :lat, :description
end
