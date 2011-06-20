# == Schema Information
# Schema version: 20110615133925
#
# Table name: announcements
#
#  id                   :integer(4)      not null, primary key
#  announcement_type_id :integer(4)
#  channel_type         :string(255)
#  business_id          :integer(4)
#  content              :text
#  created_at           :datetime
#  updated_at           :datetime
#

class Announcement < ActiveRecord::Base
  belongs_to :announcement_type
  belongs_to :business
end
