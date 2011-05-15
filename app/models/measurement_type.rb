class MeasurementType < ActiveRecord::Base
	has_many :campaigns
	has_many :accounts
	belongs_to :business
	
	validates_presence_of :name
	validates_uniqueness_of :name, :scope=>:business_id
end
