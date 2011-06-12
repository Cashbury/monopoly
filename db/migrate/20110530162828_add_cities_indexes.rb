class AddCitiesIndexes < ActiveRecord::Migration
  def self.up
    add_index  :cities, [:lat, :lng]
  end

  def self.down
    remove_index  :cities, [:lat, :lng]
  end
end
