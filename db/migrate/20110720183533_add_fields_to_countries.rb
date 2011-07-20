class AddFieldsToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :country_code, :string
    add_column :countries, :flag_image, :string
  end

  def self.down
    remove_column :countries, :flag_image
    remove_column :countries, :country_code
  end
end
