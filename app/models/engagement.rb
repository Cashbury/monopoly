class Engagement < ActiveRecord::Base
  belongs_to :campaign
  has_many :rewards
  attr_accessible :engagement_type, :stamp, :campaign_id, :state, :points, :description
  
  def engagement_types
    ["check-in", "stamp", "question", "spend"]
  end
  
  def get_states
    ["deployed", "paused", "offline"]
  end
end
