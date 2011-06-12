class CreateCampaignsPlacesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :campaigns_places, :id => false do |t|
      t.integer :campaign_id
      t.integer :place_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns_places
  end
end
