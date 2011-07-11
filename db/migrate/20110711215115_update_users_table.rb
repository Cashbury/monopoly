class UpdateUsersTable < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :home_town, :integer
    end
    add_column :users, :active, :boolean, :default=>true
  end

  def self.down
    remove_column :users, :active
    change_table :users do |t|
      t.change :home_town, :string
    end
  end
end
