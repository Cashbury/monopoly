class AddPlacesCampaignsJointTable < ActiveRecord::Migration
  def self.up
    create_table :campaigns_places, :id => false do |t|
      t.integer :place_id, :campaign_id
    end
  end

  def self.down
    drop_table :campaigns_places
  end
end
