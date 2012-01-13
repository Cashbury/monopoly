class AddTransactionGroupIdToTransactions < ActiveRecord::Migration
  def self.up
    change_table :transactions do |t|
      t.belongs_to :transaction_group
    end
  end

  def self.down
    change_table :transaction do |t|
      t.remove_belongs_to :transaction_group
    end
  end
end
