class Target < ActiveRecord::Base
	belongs_to :business
	
	has_and_belongs_to_many :campaigns
	has_and_belongs_to_many :users
end
