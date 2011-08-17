class AddIsLiveAndTimeZoneToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :is_live, :boolean
    add_column :countries, :timezone, :string
  end

  def self.down
    remove_column :countries, :timezone
    remove_column :countries, :is_live
  end
end
