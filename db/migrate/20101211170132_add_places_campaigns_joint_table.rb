class AddPlacesCampaignsJointTable < ActiveRecord::Migration
  def self.up
    create_table :places_campaigns, :id => false do |t|
      t.integer :place_id, :campaign_id
    end
  end

  def self.down
    drop_table :places_campaigns
  end
end
