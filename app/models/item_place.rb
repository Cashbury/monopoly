# == Schema Information
# Schema version: 20110615133925
#
# Table name: item_places
#
#  id         :integer(4)      not null, primary key
#  item_id    :integer(4)
#  place_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class ItemPlace < ActiveRecord::Base
  belongs_to :item
  belongs_to :place
end
