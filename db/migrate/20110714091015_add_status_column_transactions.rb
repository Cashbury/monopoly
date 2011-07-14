class AddStatusColumnTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :status, :boolean, :default=>true
  end

  def self.down
    remove_column :transactions, :status
  end
end
