class AddCurrencySymbolToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :currency_symbol, :string
  end

  def self.down
    remove_column :countries, :currency_symbol
  end
end
