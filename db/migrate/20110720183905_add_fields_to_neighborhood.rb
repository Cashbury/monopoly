class AddFieldsToNeighborhood < ActiveRecord::Migration
  def self.up
    add_column :neighborhoods, :city_id, :integer
    add_index  :neighborhoods , :city_id
  end

  def self.down
    remove_index :neighborhoods, :city_id
    remove_column :neighborhoods, :city_id
  end
end
