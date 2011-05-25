class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :from_account
      t.integer :to_account
      t.decimal :amount, :precision => 20, :scale => 3
      t.string  :account_type
      t.boolean :is_money

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
