class TransactionGroup < ActiveRecord::Base
  has_many :transactions

  validates :friendly_id, :uniqueness => true

  after_create :generate_friendly_id

  def void!(voiding_user)
    transactions.each { |tx| tx.void!(voiding_user) }
  end

  protected

  def generate_friendly_id
    self.friendly_id = "TXGRP-#{id}-#{SecureRandom.hex(3)}".upcase
    self.save!
  end

end
