class RenameTxSavingsAtReceipts < ActiveRecord::Migration
  def self.up
    rename_column :receipts, :tx_savings, :credit_used
    rename_column :receipts, :cashbury_credit_post_tx, :cashbury_act_balance
    add_column :receipts, :ringup_amount, :decimal, :precision => 20, :scale => 3, :default => 0
  end

  def self.down
    rename_column :receipts, :ringup_amount
    rename_column :receipts, :cashbury_act_balance, :cashbury_credit_post_tx
    rename_column :receipts, :credit_used, :tx_savings
  end
end
