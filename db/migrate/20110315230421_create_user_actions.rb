class CreateUserActions < ActiveRecord::Migration
  def self.up
  	drop_table :users_snaps
    create_table :user_actions do |t|
      t.integer :user_id,:null=>false
      t.integer :qr_code_id
      t.integer :business_id
      t.integer :reward_id
			t.date    :used_at
			
      t.timestamps
    end
    add_index :user_actions,:user_id
    add_index :user_actions,:qr_code_id
    add_index :user_actions,:business_id
    add_index :user_actions,:reward_id
    
  end

  def self.down
  	remove_index :user_actions,:reward_id
  	remove_index :user_actions,:business_id
  	remove_index :user_actions,:qr_code_id
  	remove_index :user_actions,:user_id
  	
    drop_table :user_actions
    
    create_table :users_snaps do |t|
      t.integer  :user_id,:null=>false
      t.integer  :qr_code_id,:null=>false
      t.datetime :used_at

      t.timestamps
    end
  end
end
