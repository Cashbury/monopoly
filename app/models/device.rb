class Device < ActiveRecord::Base
  belongs_to :user

  validates :udid, presence: true

  def activate!
      self.update_attribute(:active, true)
  end

  def deactivate!
    self.update_attribute(:active, false)
  end

end