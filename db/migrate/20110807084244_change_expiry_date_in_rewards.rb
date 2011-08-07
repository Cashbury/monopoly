class ChangeExpiryDateInRewards < ActiveRecord::Migration
  def self.up
    change_table :rewards do |t|
      t.change :expiry_date, :date
    end
  end

  def self.down
    change_table :rewards do |t|
      t.change :expiry_date, :datetime
    end
  end
end
