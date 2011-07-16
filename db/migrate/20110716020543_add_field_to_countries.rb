class AddFieldToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :nationality_singular, :string
    add_column :countries, :nationality_plural, :string
    add_column :countries, :capital, :string
    add_column :countries, :currency, :string
    add_column :countries, :currency_code, :string
    add_column :countries, :iso2, :string
    add_column :countries, :iso3, :string
    add_column :countries, :ison, :string
    add_column :countries, :internet, :string
  end

  def self.down
    remove_column :countries, :internet
    remove_column :countries, :ison
    remove_column :countries, :iso3
    remove_column :countries, :iso2
    remove_column :countries, :currency_code
    remove_column :countries, :currency
    remove_column :countries, :capital
    remove_column :countries, :nationality_plural
    remove_column :countries, :nationality_singular
  end
end
