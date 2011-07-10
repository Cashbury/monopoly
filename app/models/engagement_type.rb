class EngagementType < ActiveRecord::Base
  has_many :engagements
  belongs_to :business
end
