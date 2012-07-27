class CreateTipsNeededMigrations < ActiveRecord::Migration
  def self.up
    add_column :places, :tips_mode, :string, :default => :communal
    add_column :accounts, :is_tip, :boolean, :default => false   
    add_column :accounts, :place_id, :integer
    add_index :accounts, :place_id 
  end

  def self.down
    remove_index :accounts, :place_id
    remove_column :accounts, :place_id
    remove_column :accounts, :is_tip
    remove_column :places, :tips_mode
  end
end
