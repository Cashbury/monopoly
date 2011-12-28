class AddAboutToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :about, :text, :default => ''
  end

  def self.down
    remove_column :places, :about
  end
end
