class CampaignTarget < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :target
end