class Item < ActiveRecord::Base
	belongs_to :business
	has_many :item_places 
	has_many :places , :through => :item_places
  has_and_belongs_to_many :rewards
	has_one :item_image, :as => :uploadable, :dependent => :destroy
	has_many :engagements
	
	accepts_nested_attributes_for :places
	
	validates_presence_of :name
end
