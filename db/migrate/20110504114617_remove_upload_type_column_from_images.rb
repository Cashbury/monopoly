class RemoveUploadTypeColumnFromImages < ActiveRecord::Migration
  def self.up
    remove_column :images, :upload_type
  end

  def self.down
    add_column :images, :upload_type, :string
  end
end
