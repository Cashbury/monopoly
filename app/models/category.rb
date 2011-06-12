class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => "Category"
  has_many :children, :class_name => "Category",:foreign_key => "parent_id"
  has_and_belongs_to_many :businesses
  attr_accessible :name, :description, :parent_id
  
  validates_presence_of :name
end
