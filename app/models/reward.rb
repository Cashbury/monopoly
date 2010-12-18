# == Schema Information
# Schema version: 20101218032208
#
# Table name: rewards
#
#  id            :integer         primary key
#  name          :string(255)
#  engagement_id :integer
#  created_at    :timestamp
#  updated_at    :timestamp
#  campaign_id   :integer
#

class Reward < ActiveRecord::Base
  belongs_to :engagement
  belongs_to :campaign
  attr_accessible :name, :engagement_id
end
