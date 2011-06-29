class AddQrCodeSizeToQrCodes < ActiveRecord::Migration
  def self.up
    add_column :qr_codes, :size, :boolean
  end

  def self.down
    remove_column :qr_codes, :size
  end
end
