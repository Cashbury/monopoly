class Place < ActiveRecord::Base
  belongs_to :business
  has_and_belongs_to_many :campaigns
  attr_accessible :name, :long, :lat, :description
end
