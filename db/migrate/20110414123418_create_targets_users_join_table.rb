class CreateTargetsUsersJoinTable < ActiveRecord::Migration
  def self.up
  	create_table :targets_users, :id => false do |t|
      t.integer :target_id
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
  	drop_table :targets_users
  end
end
