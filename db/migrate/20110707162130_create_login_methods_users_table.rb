class CreateLoginMethodsUsersTable < ActiveRecord::Migration
  def self.up
    create_table :login_methods_users, :id => false do |t|
      t.references :login_method, :user
    end
  end

  def self.down
    drop_table :login_methods_users
  end
end
