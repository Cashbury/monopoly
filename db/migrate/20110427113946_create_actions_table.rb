class CreateActionsTable < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.string :name
      t.integer :transaction_type_id

      t.timestamps
    end
    rename_column :logs, :log_type, :action_id
    add_index :logs, :action_id
    add_index :actions, :name
  end

  def self.down
    remove_index :actions, :name
    remove_index :logs, :action_id
    rename_column :logs, :action_id, :log_type 
    drop_table :actions
  end
end
