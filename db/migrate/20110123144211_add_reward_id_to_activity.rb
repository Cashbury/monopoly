class AddRewardIdToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :reward_id, :integer
  end

  def self.down
    remove_column :activities, :reward_id
  end
end
