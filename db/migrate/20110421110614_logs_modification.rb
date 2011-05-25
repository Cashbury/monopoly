class LogsModification < ActiveRecord::Migration
  def self.up
    add_column :logs, :transaction_id, :integer
    rename_column :logs, :amount, :gained_amount
    change_column :logs, :frequency, :decimal, :precision => 20, :scale => 3
    add_index :logs, :engagement_id
    add_index :logs, :created_on
    add_index :logs, :created_at
  end

  def self.down
    remove_index :logs, :created_at
    remove_index :logs, :created_on
    remove_index :logs, :engagement_id
    change_column :logs, :frequency, :integer
    rename_column :logs, :gained_amount, :amount
    remove_column :logs, :transaction_id
  end
end
