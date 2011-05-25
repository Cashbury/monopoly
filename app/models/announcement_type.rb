class AnnouncementType < ActiveRecord::Base
  has_many :announcements
  validates_presence_of :name, :announcement_type_id
end
