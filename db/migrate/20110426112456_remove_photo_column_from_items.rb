class RemovePhotoColumnFromItems < ActiveRecord::Migration
  def self.up
    remove_column :items, :photo
  end

  def self.down
    add_column :items, :photo, :string
  end
end
