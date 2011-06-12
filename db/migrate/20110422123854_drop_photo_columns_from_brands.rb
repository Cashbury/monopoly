class DropPhotoColumnsFromBrands < ActiveRecord::Migration
  def self.up
    remove_column :brands, :photo_file_name
    remove_column :brands, :photo_content_type
    remove_column :brands, :photo_file_size
  end

  def self.down
    add_column :brands, :photo_file_size, :integer
    add_column :brands, :photo_content_type, :string
    add_column :brands, :photo_file_name, :string
  end
end
