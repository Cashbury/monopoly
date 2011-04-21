class DropPlacesRewardsTable < ActiveRecord::Migration
  def self.up
    drop_table :places_rewards
  end

  def self.down
    create_table "places_rewards", :id => false, :force => true do |t|
      t.integer "place_id"
      t.integer "reward_id"
    end
  end
end
