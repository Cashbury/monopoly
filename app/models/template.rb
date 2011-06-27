# == Schema Information
# Schema version: 20110615133925
#
# Table name: templates
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  back_photo  :string(255)
#  active      :boolean(1)
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  front_photo :string(255)
#  description :text
#  title       :string(255)
#  tag         :string(255)
#

class Template < ActiveRecord::Base
  belongs_to :user
  has_many :qr_codes
  mount_uploader :front_photo , ImageUploader
  mount_uploader :back_photo , ImageUploader
end
