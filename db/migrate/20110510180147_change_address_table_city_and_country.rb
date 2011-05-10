class ChangeAddressTableCityAndCountry < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :country, :country_id
    rename_column :addresses, :city, :city_id
    change_column :addresses, :country_id, :integer
    change_column :addresses, :city_id, :integer
  end

  def self.down
    change_column :addresses, :city_id, :string
    change_column :addresses, :country_id, :string 
    rename_column :addresses, :city_id, :city 
    rename_column :addresses, :country_id, :country 
  end
end
