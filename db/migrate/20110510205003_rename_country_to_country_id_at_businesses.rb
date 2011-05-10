class RenameCountryToCountryIdAtBusinesses < ActiveRecord::Migration
  def self.up
    rename_column :businesses, :country, :country_id
  end

  def self.down
    rename_column :businesses, :country_id, :country
  end
end
