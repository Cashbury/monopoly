class Item < ActiveRecord::Base
	belongs_to :business
	has_and_belongs_to_many :places
	has_and_belongs_to_many :rewards
	
	validates_presence_of :name
end
