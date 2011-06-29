class AddAddressProfileIdToCountriesTable < ActiveRecord::Migration
  def self.up
    add_column :countries, :address_profile_id, :integer
  end

  def self.down
    remove_column :countries, :address_profile_id
  end
end
