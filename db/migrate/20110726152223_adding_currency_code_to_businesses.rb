class AddingCurrencyCodeToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :currency_code, :string
  end

  def self.down
    remove_column :businesses, :currency_code
  end
end
