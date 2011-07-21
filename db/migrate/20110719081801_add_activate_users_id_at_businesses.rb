class AddActivateUsersIdAtBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :activate_users_id, :boolean
  end

  def self.down
    remove_column :businesses, :activate_users_id
  end
end
