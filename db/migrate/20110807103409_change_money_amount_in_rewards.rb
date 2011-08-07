class ChangeMoneyAmountInRewards < ActiveRecord::Migration
  def self.up
    change_table :rewards do |t|
      t.change :money_amount, :decimal, :precision=>20, :scale=>3
    end
  end

  def self.down
    change_table :rewards do |t|
      t.change :money_amount, :decimal, :precision=>20, :scale=>10
    end
  end
end
