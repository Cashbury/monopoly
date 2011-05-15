class CreateTmpImagesTable < ActiveRecord::Migration
  def self.up
    create_table :tmp_images do |t|
      t.integer   :uploadable_id
      t.string    :uploadable_type
      t.string    :photo_file_name
      t.string    :photo_content_type
      t.integer   :photo_file_size
      t.string    :upload_type
      
      t.timestamps
    end
    add_column :images, :upload_type, :string
  end

  def self.down
    #remove_column :images, :upload_type
    drop_table :tmp_images
  end
end
