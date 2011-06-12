class AddAutoUnlockColumnToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :auto_unlock, :boolean, :default=>false
  end

  def self.down
    remove_column :rewards, :auto_unlock
  end
end
