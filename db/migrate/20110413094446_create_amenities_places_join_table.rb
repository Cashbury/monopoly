class CreateAmenitiesPlacesJoinTable < ActiveRecord::Migration
  def self.up
  	create_table :amenities_places, :id => false do |t|
      t.integer :amenity_id
      t.integer :place_id
      
      t.timestamps
    end
  end

  def self.down
  	 drop_table :amenities_places
  end
end
