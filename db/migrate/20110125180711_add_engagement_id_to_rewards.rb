class AddEngagementIdToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :engagement_id, :integer
  end

  def self.down
    remove_column :rewards, :engagement_id
  end
end
