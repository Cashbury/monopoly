class AddIsReserveToAccountsTable < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.boolean :is_reserve, :null => false, :default => false
    end
  end

  def self.down
    change_table :accounts do |t|
      t.remove :is_reserve
    end
  end
end
