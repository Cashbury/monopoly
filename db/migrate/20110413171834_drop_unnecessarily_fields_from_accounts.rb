class DropUnnecessarilyFieldsFromAccounts < ActiveRecord::Migration
  def self.up
  	remove_column :accounts, :user_id
  	remove_column :accounts, :program_id
  	remove_column :accounts, :points
  end

  def self.down
  	add_column :accounts, :points, :integer
  	add_column :accounts, :program_id, :integer
  	add_column :accounts, :user_id, :integer
  end
end
