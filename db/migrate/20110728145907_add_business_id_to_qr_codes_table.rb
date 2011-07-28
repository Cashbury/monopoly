class AddBusinessIdToQrCodesTable < ActiveRecord::Migration
  def self.up
    add_column :qr_codes, :business_id, :integer, :default=>0
  end

  def self.down
    remove_column :qr_codes, :business_id
  end
end
