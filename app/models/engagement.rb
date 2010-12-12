class Engagement < ActiveRecord::Base
  belongs_to :campaign
  has_many :rewards
  attr_accessible :engagement_type, :stamp, :campaign_id
end
