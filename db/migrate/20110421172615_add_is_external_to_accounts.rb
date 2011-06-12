class AddIsExternalToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :is_external, :boolean
  end

  def self.down
    add_column :accounts, :is_external
  end
end
