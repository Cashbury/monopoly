class CreateQrCodes < ActiveRecord::Migration
  def self.up
    create_table :qr_codes do |t|
      t.string :code
      t.integer :place_id
      t.integer :engagement_id
      t.timestamps
    end
  end

  def self.down
    drop_table :qr_codes
  end
end
