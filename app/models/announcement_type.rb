class AnnouncementType < ActiveRecord::Base
  validates_precense_of :name
end
