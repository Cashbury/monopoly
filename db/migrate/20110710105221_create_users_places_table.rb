class CreateUsersPlacesTable < ActiveRecord::Migration
  def self.up
    create_table :places_users, :id => false do |t|
      t.references :place, :user
    end
    
  end

  def self.down
    drop_table :places_users
  end
end
