class RenameCountryToCountryIdAtBusinesses < ActiveRecord::Migration
  def self.up
    rename_column :businesses, :country, :country_id
    add_index :businesses, :country_id
  end

  def self.down
    remove_index :businesses, :country_id
    rename_column :businesses, :country_id, :country
  end
end
