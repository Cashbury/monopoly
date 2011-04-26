class AddExpiryDateAndExpiryIntervalToTargets < ActiveRecord::Migration
  def self.up
    add_column :targets, :expiry_date, :date
    add_column :targets, :expiry_interval, :decimal
  end

  def self.down
    remove_column :targets, :expiry_interval
    remove_column :targets, :expiry_date
  end
end
