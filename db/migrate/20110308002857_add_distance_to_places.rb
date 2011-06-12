class AddDistanceToPlaces < ActiveRecord::Migration
  def self.up
  	add_column :places, :distance, :string,:default=>"0"
  end

  def self.down
  	remove_column :places, :distance
  end
end