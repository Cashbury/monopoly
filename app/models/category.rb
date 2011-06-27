# == Schema Information
# Schema version: 20110615133925
#
# Table name: categories
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  parent_id   :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => "Category"
  has_many :children, :class_name => "Category",:foreign_key => "parent_id"
  has_and_belongs_to_many :businesses
  attr_accessible :name, :description, :parent_id
  
  validates_presence_of :name
end
