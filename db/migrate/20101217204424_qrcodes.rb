class Qrcodes < ActiveRecord::Migration
  def self.up
      create_table :qrcodes do |t|
      t.integer :engagement_id
      t.string :photo_url
      t.timestamps
    end
  end

  def self.down
    drop_table :qrcodes
  end
end
