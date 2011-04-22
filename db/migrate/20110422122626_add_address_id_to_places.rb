class AddAddressIdToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :address_id, :integer
  end

  def self.down
    remove_column :places, :address_id
  end
end
