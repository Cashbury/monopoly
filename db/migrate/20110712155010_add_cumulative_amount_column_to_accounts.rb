class AddCumulativeAmountColumnToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :cumulative_amount, :integer
  end

  def self.down
    remove_column :accounts, :cumulative_amount
  end
end
