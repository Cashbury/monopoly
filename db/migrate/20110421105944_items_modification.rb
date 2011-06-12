class ItemsModification < ActiveRecord::Migration
  def self.up
    add_column :items, :product_code, :string
    add_column :items, :cost, :decimal, :precision => 20, :scale => 3
    remove_column :items_places, :created_at
    remove_column :items_places, :updated_at
    remove_column :items_rewards, :created_at
    remove_column :items_rewards, :updated_at
  end

  def self.down
    add_column :items_rewards, :created_at, :datetime
    add_column :items_rewards, :updated_at, :datetime
    add_column :items_places, :updated_at, :datetime
    add_column :items_places, :created_at, :datetime
    remove_column :items, :cost
    remove_column :items, :product_code
  end
end
