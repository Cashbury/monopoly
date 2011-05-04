class Amenity < ActiveRecord::Base
	has_and_belongs_to_many :places
	
	validates_presence_of :name
	
end
