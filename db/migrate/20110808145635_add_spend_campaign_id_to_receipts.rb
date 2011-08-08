class AddSpendCampaignIdToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :spend_campaign_id, :integer
  end

  def self.down
    remove_column :receipts, :spend_campaign_id
  end
end
