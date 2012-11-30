class Device < ActiveRecord::Base
  belongs_to :user

  validates :udid, presence: true

end
