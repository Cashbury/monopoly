class CreateAmenities < ActiveRecord::Migration
  def self.up
    create_table :amenities do |t|
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :amenities
  end
end
