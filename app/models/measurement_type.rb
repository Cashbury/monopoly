class MeasurementType < ActiveRecord::Base
	has_many :campaigns
	has_many :accounts
	
	validates_presence_of :name
end
