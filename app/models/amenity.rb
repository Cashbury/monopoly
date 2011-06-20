# == Schema Information
# Schema version: 20110615133925
#
# Table name: amenities
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Amenity < ActiveRecord::Base
	has_and_belongs_to_many :places
	validates_presence_of :name
end
