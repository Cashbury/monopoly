class CreateTmpUploadsTable < ActiveRecord::Migration
  def self.up
    create_table :tmp_uploads do |t|
      t.integer   :uploadable_id
      t.string    :uploadable_type
      t.string    :photo_file_name
      t.string    :photo_content_type
      t.integer   :photo_file_size
      t.string    :upload_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tmp_uploads
  end
end
