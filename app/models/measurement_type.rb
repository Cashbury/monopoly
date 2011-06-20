# == Schema Information
# Schema version: 20110615133925
#
# Table name: measurement_types
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  business_id :integer(4)
#

class MeasurementType < ActiveRecord::Base
	has_many :campaigns
	has_many :accounts
	belongs_to :business
	
	validates_presence_of :name
	validates_uniqueness_of :name, :scope=>:business_id
end
