class Announcement < ActiveRecord::Base
  belongs_to :announcement_type
  belongs_to :business
end
