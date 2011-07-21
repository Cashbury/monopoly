class AddTimeZoneToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :time_zone, :string
  end

  def self.down
    remove_column :cities, :time_zone
  end
end
