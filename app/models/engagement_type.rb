# == Schema Information
# Schema version: 20110615133925
#
# Table name: engagement_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  has_item   :boolean(1)
#  is_visit   :boolean(1)
#

class EngagementType < ActiveRecord::Base
  has_many :engagements
  belongs_to :business
end
