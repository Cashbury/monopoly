class AddFbMessagesToRewardsTable < ActiveRecord::Migration
  def self.up
    add_column :rewards, :fb_unlock_msg, :string
    add_column :rewards, :fb_enjoy_msg, :string
  end

  def self.down
    remove_column :rewards, :fb_enjoy_msg
    remove_column :rewards, :fb_unlock_msg
  end
end
