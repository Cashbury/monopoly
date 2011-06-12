class TransactionsModification < ActiveRecord::Migration
  def self.up
    add_column :transactions, :from_account_balance_before, :decimal, :precision => 20, :scale => 3 
    add_column :transactions, :from_account_balance_after, :decimal, :precision => 20, :scale => 3
    add_column :transactions, :to_account_balance_before, :decimal, :precision => 20, :scale => 3 
    add_column :transactions, :to_account_balance_after, :decimal, :precision => 20, :scale => 3
    add_column :transactions, :currency, :string
    add_column :transactions, :note, :text
  end

  def self.down
    remove_column :transactions, :note
    remove_column :transactions, :currency_id
    remove_column :transactions, :to_account_balance_after
    remove_column :transactions, :to_account_balance_before
    remove_column :transactions, :from_account_balance_after
    remove_column :transactions, :from_account_balance_before
  end
end
