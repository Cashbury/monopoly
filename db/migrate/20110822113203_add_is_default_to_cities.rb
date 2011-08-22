class AddIsDefaultToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :is_default, :boolean
    add_index :cities, :is_default
    City.update_all({:is_default=>true},['name like ?', "San Francisco"])
  end

  def self.down
    remove_index :cities, :is_default
    remove_column :cities, :is_default
  end
end
