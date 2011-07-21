class AddMoneyAmountAtRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :money_amount, :decimal, :precision=>20, :scale=>10
  end

  def self.down
    remove_column :rewards, :money_amount
  end
end
