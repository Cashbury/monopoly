class DropPhotoFieldsFromBrands < ActiveRecord::Migration
  def self.up
    remove_column :qr_codes, :image_file_name
    remove_column :qr_codes, :image_content_type
    remove_column :qr_codes, :image_file_size
  end

  def self.down
    add_column :qr_codes, :image_file_name, :string
    add_column :qr_codes, :image_content_type, :string
    add_column :qr_codes, :image_file_size, :integer
  end
end
