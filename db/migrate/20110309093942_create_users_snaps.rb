class CreateUsersSnaps < ActiveRecord::Migration
  def self.up
    create_table :users_snaps do |t|
      t.integer  :user_id,:null=>false
      t.integer  :qr_code_id,:null=>false
      t.datetime :used_at

      t.timestamps
    end
  end

  def self.down
    drop_table :users_snaps
  end
end
