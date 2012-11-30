class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      t.references :user
      t.string :udid
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :devices, :user_id
    add_index :devices, :udid, unique: true
    add_index :devices, :active
  end

  def self.down
    drop_table :devices
  end
end
