class RenamePhotoFieldAtBrands < ActiveRecord::Migration
  def self.up
    rename_column :brands, :photo, :photo_file_name
    add_column :brands, :photo_content_type, :string
    add_column :brands, :photo_file_size, :integer
  end

  def self.down
    remove_column :brands, :photo_file_size
    remove_column :brands, :photo_content_type
    rename_column :brands, :photo_file_name, :photo
  end
end
