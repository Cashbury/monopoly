class CreateItemsRewardsJoinTable < ActiveRecord::Migration
  def self.up
  	create_table :items_rewards, :id => false do |t|
      t.integer :reward_id
      t.integer :item_id
      
      t.timestamps
    end
  end

  def self.down
  	drop_table :items_rewards
  end
end
