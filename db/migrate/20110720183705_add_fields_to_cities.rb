class AddFieldsToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :area_code, :string
    add_column :cities, :is_live, :boolean

  end

  def self.down
    remove_column :cities, :is_live
    remove_column :cities, :area_code
  end
end
