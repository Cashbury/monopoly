class AddRewardIdToEngagements < ActiveRecord::Migration
  def self.up
    add_column :engagements, :reward_id, :integer
  end

  def self.down
    remove_column :engagements, :reward_id
  end
end
