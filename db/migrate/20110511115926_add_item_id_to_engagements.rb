class AddItemIdToEngagements < ActiveRecord::Migration
  def self.up
    add_column :engagements, :item_id, :integer
    add_column :engagement_types, :has_item, :boolean
  end

  def self.down
    remove_column :engagement_types, :has_item
    remove_column :engagements, :item_id
  end
end
