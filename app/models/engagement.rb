# == Schema Information
# Schema version: 20101218032208
#
# Table name: engagements
#
#  id              :integer         primary key
#  engagement_type :string(255)
#  points          :string(255)
#  state           :string(255)
#  description     :string(255)
#  campaign_id     :integer
#  created_at      :timestamp
#  updated_at      :timestamp
#  name            :string(255)
#

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
