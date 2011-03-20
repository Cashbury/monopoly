class ChangeColumnTypeInQrCodes < ActiveRecord::Migration
  def self.up
    rename_column :qr_codes , :print_job_id , :exported
    change_column :qr_codes , :exported , :boolean , :default=>false
  end

  def self.down
    rename_column :qr_codes , :exported ,:print_job_id
    change_column :qr_codes , :print_job_id , :integer
  end
end
