class AddIssuedByColumnToQrCodes < ActiveRecord::Migration
  def self.up
    add_column :qr_codes, :issued_by, :integer, :default=> 0 #system
  end

  def self.down
    remove_column :qr_codes, :issued_by
  end
end
