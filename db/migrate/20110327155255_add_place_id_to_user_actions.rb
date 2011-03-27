class AddPlaceIdToUserActions < ActiveRecord::Migration
  def self.up
    add_column :user_actions, :place_id, :integer
  end

  def self.down
    remove_column :user_actions, :place_id
  end
end
