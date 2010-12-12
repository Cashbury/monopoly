class Reward < ActiveRecord::Base
  belongs_to :engagement
  attr_accessible :name, :engagement_id
end
