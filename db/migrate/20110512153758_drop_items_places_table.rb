class DropItemsPlacesTable < ActiveRecord::Migration
  def self.up
    drop_table :items_places
  end

  def self.down
    create_table :items_places, :id => false do |t|
      t.integer :item_id
      t.integer :place_id
      
      t.timestamps
    end
  end
end
