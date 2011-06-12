class CreateRewardsUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :rewards_users, :id => false do |t|
      t.integer  "user_id"
      t.integer  "reward_id"
    end
    add_index :rewards_users, :user_id
    add_index :rewards_users, :reward_id
  end

  def self.down
    remove_index :rewards_users, :user_id
    remove_index :rewards_users, :reward_id
    drop_table :rewards_users
  end
end
