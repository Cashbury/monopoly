class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :country
      t.string :city
      t.string :zipcode
      t.string :neighborhood
      t.string :street_address

      t.timestamps
    end
    remove_column :places, :country
    remove_column :places, :city
    remove_column :places, :zipcode
    remove_column :places, :neighborhood
    remove_column :places, :address1
    remove_column :places, :address2
  end

  def self.down
    add_column :places, :address2, :string
    add_column :places, :address1, :string
    add_column :places, :neighborhood, :string
    add_column :places, :zipcode, :string
    add_column :places, :city, :string
    add_column :places, :country, :string
    drop_table :addresses
  end
end
