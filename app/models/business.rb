class Business < ActiveRecord::Base
  has_many :places
  has_and_belongs_to_many :categories
  attr_accessible :name, :description
end
