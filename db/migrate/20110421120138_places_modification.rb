class PlacesModification < ActiveRecord::Migration
  def self.up
    add_column :places, :place_type_id, :integer
    add_column :places, :is_user_defined, :boolean
    add_index :places, :place_type_id
  end

  def self.down
    remove_index :places, :place_type_id
    remove_column :places, :is_user_defined
    remove_column :places, :place_type_id
  end
end
