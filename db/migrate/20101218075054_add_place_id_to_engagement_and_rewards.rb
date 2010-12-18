class AddPlaceIdToEngagementAndRewards < ActiveRecord::Migration
  def self.up
    add_column :engagements, :place_id , :integer
    add_column :rewards, :place_id , :integer
  end

  def self.down
    remove_column :engagements ,:place_id
    remove_column :rewards,:place_id
  end
end
