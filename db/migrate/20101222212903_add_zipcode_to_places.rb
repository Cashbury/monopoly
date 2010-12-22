class AddZipcodeToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :address2, :string
    add_column :places, :zipcode, :string
    add_column :places, :country, :string
    rename_column :places, :address , :address1
  end

  def self.down
    remove_column :places, :country    
    remove_column :places, :zipcode
    remove_column :places, :address2
    rename_column :places, :address1 , :address
  end
end
