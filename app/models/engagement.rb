class Engagement < ActiveRecord::Base
  belongs_to :campaign
  has_many :rewards
  attr_accessible :engagement_type,:name,  :stamp, :campaign_id, :state, :points, :description
 
  validates :name , :presence =>true,
                    :length =>{:within=>3..50}

  def engagement_types
    ["check-in", "stamp", "question", "spend"]
  end
  
  def get_states
    ["deployed", "paused", "offline"]
  end
end
