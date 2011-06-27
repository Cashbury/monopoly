# == Schema Information
# Schema version: 20110615133925
#
# Table name: targets
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  description     :string(255)
#  business_id     :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  expiry_date     :date
#  expiry_interval :integer(10)
#

class Target < ActiveRecord::Base
	belongs_to :business
	# has_many   :campaign_targets
	#   has_many   :campaigns, :through=>:campaign_targets
	has_and_belongs_to_many :campaigns
	has_and_belongs_to_many :users
	#accepts_nested_attributes_for :campaigns
	TARGETS_LABELS={
	  "new_comers"=>"Attract New Customers",
	  "returning_comers"=>"Attract Existing Customers"
	}
	def display_name
	  TARGETS_LABELS[self.name]
	end
end
