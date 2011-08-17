class ReanameCurrencyIconOfCountries < ActiveRecord::Migration
  def self.up
    rename_column :countries, :currency_icon, :currency_icon_file_name
  end

  def self.down
    rename_column :countries, :currency_icon_file_name ,:currency_icon
  end
end
