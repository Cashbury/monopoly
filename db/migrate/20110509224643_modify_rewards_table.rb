class ModifyRewardsTable < ActiveRecord::Migration
  def self.up
    add_column :rewards, :sales_price, :decimal, :precision=>20, :scale=>3
    add_column :rewards, :offer_price, :decimal, :precision=>20, :scale=>3,:default=>0
    add_column :rewards, :cost, :decimal, :precision=>20, :scale=>3
    add_column :rewards, :foreign_identifier, :string
  end

  def self.down
    remove_column :rewards, :foreign_identifier
    remove_column :rewards, :cost
    remove_column :rewards, :offer_price
    remove_column :rewards, :sales_price
  end
end
