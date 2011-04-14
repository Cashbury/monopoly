class AddPhotoToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :photo, :string
  end

  def self.down
    remove_column :brands, :photo
  end
end
