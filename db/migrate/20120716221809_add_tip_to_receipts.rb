class AddTipToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :tip, :decimal, :precision => 20, :scale => 3, :default => 0
  end

  def self.down
    remove_column :receipts, :tip
  end
end
