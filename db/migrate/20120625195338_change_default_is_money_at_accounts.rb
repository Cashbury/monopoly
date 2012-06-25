class ChangeDefaultIsMoneyAtAccounts < ActiveRecord::Migration
  def self.up
    change_column :accounts, :is_money, :boolean, :default => false
  end

  def self.down
    change_column :accounts, :is_money, :boolean, :default => nil
  end
end
