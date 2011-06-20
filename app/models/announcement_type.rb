# == Schema Information
# Schema version: 20110615133925
#
# Table name: announcement_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class AnnouncementType < ActiveRecord::Base
  has_many :announcements
  validates_presence_of :name, :announcement_type_id
end
