class QrCodesModification < ActiveRecord::Migration
  def self.up
    remove_index :qr_codes, [:related_type, :hash_code]
    add_index :qr_codes, :hash_code
    rename_column :qr_codes, :related_id, :associated_id
    rename_column :qr_codes, :related_type, :associated_type
    drop_table :qrcodes
  end

  def self.down
    create_table "qrcodes", :force => true do |t|
      t.integer  "engagement_id"
      t.string   "photo_url"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    rename_column :qr_codes, :associated_id, :related_id 
    rename_column :qr_codes, :associated_type, :related_type 
    remove_index :qr_codes, :hash_code
    add_index :qr_codes, [:related_type, :hash_code]
  end
end
