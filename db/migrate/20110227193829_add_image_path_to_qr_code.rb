class AddImagePathToQrCode < ActiveRecord::Migration
  def self.up
    add_column :qr_codes, :path, :string
  end

  def self.down
    remove_column :qr_codes, :path
  end
end
