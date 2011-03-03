class AddTypeStatusToQrCode < ActiveRecord::Migration
  def self.up
    add_column :qr_codes, :type, :boolean
    add_column :qr_codes, :status, :boolean
    add_column :qr_codes, :point, :integer
  end

  def self.down
    remove_column :qr_codes, :status
    remove_column :qr_codes, :type
    remove_column :qr_codes, :point
  end
end
