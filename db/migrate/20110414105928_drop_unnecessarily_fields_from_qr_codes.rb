class DropUnnecessarilyFieldsFromQrCodes < ActiveRecord::Migration
  def self.up
    remove_column :qr_codes, :place_id
    remove_column :qr_codes, :engagement_id
    remove_column :qr_codes, :unique_code
    remove_column :qr_codes, :point
  end

  def self.down
    add_column :qr_codes, :point, :integer
    add_column :qr_codes, :unique_code, :string
    add_column :qr_codes, :engagement_id, :integer
    add_column :qr_codes, :place_id, :integer
  end
end
