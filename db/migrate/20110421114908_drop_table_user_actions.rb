class DropTableUserActions < ActiveRecord::Migration
  def self.up
    remove_index :user_actions, :user_id
    remove_index :user_actions, :reward_id
    remove_index :user_actions, :qr_code_id
    remove_index :user_actions, :business_id
    drop_table :user_actions
  end

  def self.down
    create_table "user_actions", :force => true do |t|
      t.integer  "user_id",     :null => false
      t.integer  "qr_code_id"
      t.integer  "business_id"
      t.integer  "reward_id"
      t.date     "used_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "place_id"
    end
    add_index :user_actions, :business_id
    add_index :user_actions, :qr_code_id
    add_index :user_actions, :reward_id
    add_index :user_actions, :user_id
  end
end
