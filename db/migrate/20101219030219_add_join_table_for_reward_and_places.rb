class AddJoinTableForRewardAndPlaces < ActiveRecord::Migration
  def self.up
    create_table :places_rewards ,:id=>false do |t|
      t.integer :place_id, :reward_id
    end  end

  def self.down
    drop_table :places_rewards
  end
end
