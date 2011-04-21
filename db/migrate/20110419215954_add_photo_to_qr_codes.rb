class AddPhotoToQrCodes < ActiveRecord::Migration
  def self.up
    add_column :qr_codes, :image_file_name, :string
    add_column :qr_codes, :image_content_type, :string
    add_column :qr_codes, :image_file_size, :integer
  end

  def self.down
    remove_column :qr_codes, :image_file_name
    remove_column :qr_codes, :image_content_type
    remove_column :qr_codes, :image_file_size
  end
end
