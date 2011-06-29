class AddQrCodeIdToLogsTable < ActiveRecord::Migration
  def self.up
    add_column :logs, :qr_code_id, :integer
    add_index :logs, :qr_code_id
    add_index :logs, [:qr_code_id,:created_at]
  end

  def self.down
    remove_index :logs, [:qr_code_id,:created_at]
    remove_index :logs, :qr_code_id
    remove_column :logs, :qr_code_id
  end
end
