class ModifyEmployessTable < ActiveRecord::Migration
  def self.up
    add_column :employees, :user_id, :integer
    remove_column :employees, :full_name
    remove_column :employees, :email
    remove_column :employees, :phone_number
  end

  def self.down
    remove_column :employees, :phone_number, :string
    add_column :employees, :email, :string
    add_column :employees, :full_name, :string
    remove_column :employees, :user_id
  end
end
