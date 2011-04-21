class DropBusinessesPlacesTable < ActiveRecord::Migration
  def self.up
    drop_table :businesses_places
  end

  def self.down
    create_table "businesses_places", :id => false, :force => true do |t|
      t.integer "place_id"
      t.integer "campaign_id"
    end
  end
end
