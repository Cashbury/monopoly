class RemoveRewardMoneyAmountFromRewards < ActiveRecord::Migration
  def self.up
    remove_column :rewards, :reward_money_amount
    add_column :receipts, :transaction_id, :integer
    add_column :receipts, :log_group_id, :integer
  end

  def self.down
    remove_column :receipts, :log_group_id
    remove_column :receipts, :transaction_id
    add_column :rewards, :reward_money_amount, :decimal, :precision=>20, :scale=> 3
  end
end
