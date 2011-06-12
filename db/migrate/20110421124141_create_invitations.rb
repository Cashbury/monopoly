class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :from_user_id
      t.string :to_email
      t.string :to_phone_number
      t.boolean :state

      t.timestamps
    end
    add_index :invitations, :to_email
    add_index :invitations, :to_phone_number
  end

  def self.down
    remove_index :invitations, :to_email
    remove_index :invitations, :to_phone_number
    drop_table :invitations
  end
end
