class CreateBusinessCustomers < ActiveRecord::Migration
  def self.up
    create_table :business_customers do |t|
      t.integer :business_id
      t.integer :user_id
      t.string  :user_type
      t.timestamps
    end
    add_index :business_customers, :business_id
    add_index :business_customers, :user_id
    add_index :business_customers, [:user_id,:business_id]
  end

  def self.down
    remove_index :business_customers, [:user_id,:business_id]
    remove_index :business_customers, :user_id
    remove_index :business_customers, :business_id
    drop_table :business_customers
  end
end
