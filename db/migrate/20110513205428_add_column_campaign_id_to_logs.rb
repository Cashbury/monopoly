class AddColumnCampaignIdToLogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :campaign_id, :integer
    add_index :logs, [:user_id,:campaign_id]
  end

  def self.down
    remove_index :logs, [:user_id,:campaign_id]
    remove_column :logs, :campaign_id
  end
end
