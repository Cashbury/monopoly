class ChangeAmountAndCumulativeAmountDefaultValues < ActiveRecord::Migration
  def self.up
    change_column_default :accounts, :amount, 0
    change_table :accounts do |t|
      t.change :cumulative_amount, :decimal, :precision=>20, :scale=>3, :default=>0
    end
  end

  def self.down
    change_column_default :accounts, :amount, nil
    change_table :accounts do |t|
      t.change :cumulative_amount, :integer, :default=>nil
    end
  end
end
