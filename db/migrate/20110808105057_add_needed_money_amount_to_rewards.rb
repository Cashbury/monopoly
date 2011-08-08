class AddNeededMoneyAmountToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards,:needed_money_amount, :decimal, :precision=>20, :scale=>3
  end

  def self.down
    remove_column :rewards, :needed_money_amount
  end
end
