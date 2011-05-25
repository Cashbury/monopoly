class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string  :full_name
      t.string  :email
      t.string  :phone_number
      t.string  :position
      t.integer :employee_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
