class AddTxSavingsToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :tx_savings, :decimal, :precision => 20, :scale => 3, :default => 0
    add_column :receipts, :cashbury_credit_post_tx, :decimal, :precision => 20, :scale => 3, :default => 0    
  end

  def self.down
    remove_column :receipts, :cashbury_credit_post_tx
    remove_column :receipts, :tx_savings    
  end
end
