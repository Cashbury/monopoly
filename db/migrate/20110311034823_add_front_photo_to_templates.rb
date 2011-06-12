class AddFrontPhotoToTemplates < ActiveRecord::Migration
  def self.up
    add_column :templates, :front_photo, :string
    rename_column :templates , :photo , :back_photo
  end

  def self.down
    remove_column :templates, :front_photo
    rename_column :templates , :back_photo ,:photo
  end
end
