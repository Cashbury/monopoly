class RemoveDistanceFromPlaces < ActiveRecord::Migration
  def self.up
    remove_column :places, :distance
  end

  def self.down
    add_column :places, :distance, :float
  end
end
