class Activity < ActiveRecord::Base
  attr_accessible :user_id, :engagement_id, :place_id, :points, :type
end
