class AddAddressNeighborhoodCityToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :address, :string , :limit=>255
    add_column :places, :neighborhood, :string , :limit=>255
    add_column :places, :city, :string , :limit=>255
  end

  def self.down
    remove_column :places, :city
    remove_column :places, :neighborhood
    remove_column :places, :address
  end
end
