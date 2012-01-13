class TransactionGroup < ActiveRecord::Base
  has_many :transactions

  validates :friendly_id, :uniqueness => true

  after_create :generate_friendly_id

  protected

  def generate_friendly_id
    self.friendly_id = "TXGRP-#{id}-#{SecureRandom.hex(3)}".upcase
    self.save!
  end

end
