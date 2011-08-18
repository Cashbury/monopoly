class AddIndexesToReceiptsTable < ActiveRecord::Migration
  def self.up
    add_index :receipts, :transaction_id
    add_index :receipts, :log_group_id
    add_index :receipts, :user_id
  end

  def self.down
    remove_index :receipts, :user_id
    remove_index :receipts, :log_group_id
    remove_index :receipts, :transaction_id
  end
end
