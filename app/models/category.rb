# == Schema Information
# Schema version: 20101218032208
#
# Table name: categories
#
#  id          :integer         primary key
#  name        :string(255)
#  description :text
#  parent_id   :integer
#  created_at  :timestamp
#  updated_at  :timestamp
#

class Category < ActiveRecord::Base
  has_and_belongs_to_many :businesses
  attr_accessible :name, :description, :parent_id
end
