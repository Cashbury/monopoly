class CreateItemsPlacesJoinTable < ActiveRecord::Migration
  def self.up
  	create_table :items_places, :id => false do |t|
      t.integer :place_id
      t.integer :item_id
      
      t.timestamps
    end
  end

  def self.down
  	 drop_table :items_places
  end
end
