class RemoveUploadTypeColumnFromImages < ActiveRecord::Migration
  def self.up
    remove_column :images, :upload_type
  end

  def self.down
    add_column :upload_type, :images, :string
  end
end
