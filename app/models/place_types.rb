# == Schema Information
# Schema version: 20110615133925
#
# Table name: place_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PlaceTypes < ActiveRecord::Base
  has_many :places
end
