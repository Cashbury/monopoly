class CreateItemPlacesTable < ActiveRecord::Migration
  def self.up
    create_table :item_places do |t|
      t.integer :item_id
      t.integer :place_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :item_places
  end
end
