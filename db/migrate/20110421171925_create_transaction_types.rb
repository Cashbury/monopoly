class CreateTransactionTypes < ActiveRecord::Migration
  def self.up
    create_table :transaction_types do |t|
      t.string :name
      t.decimal :fee_amount, :precision=>20, :scale=>3
      t.decimal :fee_percentage, :precision=>20, :scale=>3
      
      t.timestamps
    end
  end

  def self.down
    drop_table :transaction_types
  end
end
