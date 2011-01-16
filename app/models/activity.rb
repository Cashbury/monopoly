class Activity < ActiveRecord::Base
  attr_accessible :account_id, :engagement_id, :place_id, :reward_id, :points, :type
end
