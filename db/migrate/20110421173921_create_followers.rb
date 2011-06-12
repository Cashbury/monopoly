class CreateFollowers < ActiveRecord::Migration
  def self.up
    create_table :followers do |t|
      t.integer :user_id
      t.integer :business_id
      t.string :user_email
      t.string :user_phone_number

      t.timestamps
    end
  end

  def self.down
    drop_table :followers
  end
end
