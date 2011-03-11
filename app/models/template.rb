class Template < ActiveRecord::Base
  belongs_to :user
  has_many :qr_codes
  mount_uploader :photo , ImageUploader
end
