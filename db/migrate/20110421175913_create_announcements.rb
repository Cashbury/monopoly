class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.integer :announcement_type_id
      t.string :channel_type
      t.integer :business_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
