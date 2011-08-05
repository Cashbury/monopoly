class AddSymbolAndIconToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :currency_icon , 	:string
  end

  def self.down
    remove_column :countries, :currency_icon
  end
end
