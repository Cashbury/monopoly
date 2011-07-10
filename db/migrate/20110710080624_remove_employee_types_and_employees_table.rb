class RemoveEmployeeTypesAndEmployeesTable < ActiveRecord::Migration
  def self.up
    drop_table :employee_types
    drop_table :employees
    all_roles=Role.find_by_sql("select * from roles_users")
    drop_table :roles_users
    create_table :roles_users do |t|
      t.references :role, :user, :business
    end
    all_roles.each do |urole|
      Employee.create(:user_id=>urole.user_id, :role_id=>urole.role_id)
    end
  end

  def self.down
    all_roles=Role.find_by_sql("select * from roles_users")
    drop_table :roles_users
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
    all_roles.each do |urole|
      Employee.create(:user_id=>urole.user_id, :role_id=>urole.role_id)
    end
    create_table :employees do |t|  
      t.string  :position
      t.integer :employee_type_id
      t.integer :user_id
      t.timestamps
    end
    create_table :employee_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
