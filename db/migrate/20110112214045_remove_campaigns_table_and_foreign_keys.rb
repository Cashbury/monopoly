class RemoveCampaignsTableAndForeignKeys < ActiveRecord::Migration
  def self.up
    rename_table :campaigns_places, :businesses_places
    drop_table :campaigns
    rename_column :engagements, :campaign_id, :business_id
    rename_column :rewards, :engagement_id, :business_id
    remove_column :rewards, :campaign_id
  end

  def self.down
  end
end
