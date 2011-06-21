# == Schema Information
# Schema version: 20110615133925
#
# Table name: brands
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Brand < ActiveRecord::Base
  belongs_to :user
  has_many :businesses
  has_one :brand_image, :as => :uploadable, :dependent => :destroy

  validates_presence_of :name
end
