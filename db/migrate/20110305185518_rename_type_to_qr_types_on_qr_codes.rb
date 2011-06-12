class RenameTypeToQrTypesOnQrCodes < ActiveRecord::Migration
  def self.up
    rename_column :qr_codes, :type , :code_type
    rename_column :qr_codes, :path , :unique_code
  end

  def self.down
    rename_column :qr_codes, :code_type , :type
    rename_column :qr_codes,:unique_code,  :path  
  end
end
