class AddColumnStatusToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :status, :boolean, :default=>true
  end

  def self.down
    remove_column :accounts, :status
  end
end
