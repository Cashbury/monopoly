class Category < ActiveRecord::Base
  has_and_belongs_to_many :businesses
  attr_accessible :name, :description, :parent_id
end
