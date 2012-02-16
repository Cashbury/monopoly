class AddTxnGroupIdToReceipt < ActiveRecord::Migration
  def self.up
    add_column :receipts, :transaction_group_id, :integer, :null => true
  end

  def self.down
    remove_column :receipts, :transaction_group_id
  end
end
