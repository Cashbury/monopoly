class CreateUsersReceiptsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :users_pending_receipts , :id => false do |t|
       t.integer :user_id
       t.integer :receipt_id
       
       t.timestamps
     end
     add_index :users_pending_receipts, [:user_id, :receipt_id]
     add_column :receipts, :cashier_id, :integer
     add_index :receipts, :cashier_id
  end

  def self.down
    remove_index :receipts, :cashier_id
    remove_column :receipts, :cashier_id
    remove_index :users_pending_receipts
    drop_table :users_pending_receipts
  end
end
