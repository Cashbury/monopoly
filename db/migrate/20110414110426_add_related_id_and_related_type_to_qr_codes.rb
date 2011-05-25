class AddRelatedIdAndRelatedTypeToQrCodes < ActiveRecord::Migration
  def self.up
  	add_column :qr_codes, :related_id, :integer
  	add_column :qr_codes, :related_type, :string
  end

  def self.down
  	remove_column :qr_codes, :related_type
  	remove_column :qr_codes, :related_id
  	
  end
end
