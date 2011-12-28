class RemoveDescriptionFromPlaces < ActiveRecord::Migration
  def self.up
    remove_column :places, :description
  end

  def self.down
    add_column :places, :description, :text
  end
end
