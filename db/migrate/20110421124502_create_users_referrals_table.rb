class CreateUsersReferralsTable < ActiveRecord::Migration
  def self.up
    create_table "users_referrals", :force => true do |t|
      t.integer "referrer_id"
      t.integer "referred_id"
    end
    add_index :users_referrals, :referrer_id
    add_index :users_referrals, :referred_id
  end

  def self.down
    remove_index :users_referrals, :referrer_id
    remove_index :users_referrals, :referred_id
    drop_table :users_referrals
  end
end
