class Activity < ActiveRecord::Base
  attr_accessible :user, :engagement, :place, :points, :type
end
