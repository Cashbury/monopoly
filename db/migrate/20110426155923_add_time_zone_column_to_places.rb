class AddTimeZoneColumnToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :time_zone, :string
  end

  def self.down
    remove_column :places, :time_zone
  end
end
