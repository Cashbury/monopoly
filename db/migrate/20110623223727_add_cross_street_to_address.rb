class AddCrossStreetToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :cross_street, :string
  end

  def self.down
    remove_column :addresses, :cross_street
  end
end
