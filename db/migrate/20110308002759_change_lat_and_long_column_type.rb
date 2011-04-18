class ChangeLatAndLongColumnType < ActiveRecord::Migration
  def self.up
		change_column :places,:lat,:decimal, :precision => 15, :scale => 10
		change_column :places,:long,:decimal, :precision => 15, :scale => 10
		add_index  :places, [:lat, :long]
  end

  def self.down
  	remove_index  :places, [:lat, :long]
  	change_column :places,:lat,:string
		change_column :places,:long,:string
  end
end
