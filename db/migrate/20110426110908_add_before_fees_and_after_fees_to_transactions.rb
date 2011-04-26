class AddBeforeFeesAndAfterFeesToTransactions < ActiveRecord::Migration
  def self.up
    rename_column :transactions, :amount, :before_fees_amount
    add_column :transactions, :after_fees_amount, :decimal, :precision=>20, :scale=>3
    add_column :transactions, :transaction_fees, :decimal, :precision=>20, :scale=>3
    
  end

  def self.down
    remove_column :transactions, :transaction_fees
    remove_column :transactions, :after_fees_amount
    rename_column :transactions, :before_fees_amount, :amount 
  end
end
