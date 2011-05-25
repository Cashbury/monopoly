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
