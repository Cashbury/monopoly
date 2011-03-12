class Template < ActiveRecord::Base
  belongs_to :user
  has_many :qr_codes
  mount_uploader :front_photo , ImageUploader
  mount_uploader :back_photo , ImageUploader
end
