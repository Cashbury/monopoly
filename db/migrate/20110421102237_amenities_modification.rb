class AmenitiesModification < ActiveRecord::Migration
  def self.up
    rename_column :amenities, :description, :name
    remove_column :amenities_places, :created_at
    remove_column :amenities_places, :updated_at
  end

  def self.down
    add_column :amenities_places, :updated_at, :datetime
    add_column :amenities_places, :created_at, :datetime
    rename_column :amenities, :name, :description
  end
end
