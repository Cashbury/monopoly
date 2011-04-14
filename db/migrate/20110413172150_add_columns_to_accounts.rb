class AddColumnsToAccounts < ActiveRecord::Migration
  def self.up
  	add_column :accounts, :account_holder_id, :integer
  	add_column :accounts, :campaign_id, :integer
  	add_column :accounts, :measurement_type_id, :integer
  	add_column :accounts, :amount, :decimal, :precision => 20, :scale => 3
  	add_column :accounts, :is_money, :boolean
  end

  def self.down
  	remove_column :accounts, :is_money
  	remove_column :accounts, :amount
  	remove_column :accounts, :measurement_type_id
  	remove_column :accounts, :campaign_id
  	remove_column :accounts, :account_holder_id
  end
end
