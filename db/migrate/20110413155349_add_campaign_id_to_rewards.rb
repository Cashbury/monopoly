class AddCampaignIdToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :campaign_id, :integer
  end

  def self.down
    remove_column :rewards, :campaign_id
  end
end
