class RemoveColumnsFromReceipts < ActiveRecord::Migration
  def self.up
    remove_column :receipts, :business_id
    remove_column :receipts, :place_id
    remove_column :receipts, :amount
    remove_column :receipts, :spend_campaign_id
  end

  def self.down
    add_column :receipts, :spend_campaign_id, :integer
    add_column :receipts, :amount, :integer
    add_column :receipts, :place_id, :integer
    add_column :receipts, :business_id, :integer
  end
end
