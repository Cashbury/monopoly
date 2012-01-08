class AddTransactionStateToTransactionsTable < ActiveRecord::Migration
  def self.up
    change_table :transactions do |t|
      t.string :state
    end
  end

  def self.down
    change_table :transactions do |t|
      t.remove :state
    end
  end
end
