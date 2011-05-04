class AddCountryIntoBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :country , :string
  end

  def self.down
    remove_column :businesses, :country
  end
end
