class CreateUsersEnjoyedRewardsTable < ActiveRecord::Migration
  def self.up
     create_table :users_enjoyed_rewards , :id => false do |t|
       t.integer :user_id
       t.integer :reward_id
       
       t.timestamps
     end
  end

  def self.down
    drop_table :users_enjoyed_rewards
  end
end
