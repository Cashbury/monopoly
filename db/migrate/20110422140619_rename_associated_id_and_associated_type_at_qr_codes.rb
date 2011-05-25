class RenameAssociatedIdAndAssociatedTypeAtQrCodes < ActiveRecord::Migration
  def self.up
    rename_column :qr_codes, :associated_id, :associatable_id
    rename_column :qr_codes, :associated_type, :associatable_type
  end

  def self.down
    rename_column :qr_codes, :associatable_type, :associated_type 
    rename_column :qr_codes, :associatable_id, :associated_id
  end
end
