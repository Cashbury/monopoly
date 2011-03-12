class AddPrintJobIdToQrCodes < ActiveRecord::Migration
  def self.up
    add_column :qr_codes, :print_job_id, :integer
  end

  def self.down
    remove_column :qr_codes, :print_job_id
  end
end
