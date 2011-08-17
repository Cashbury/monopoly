class AddGooglePlaceAndFoursquareReferenceToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :google_reference,      :string
    add_column :places, :foursquare_reference,  :string
  end

  def self.down
    remove_column :places, :google_reference
    remove_column :places, :foursquare_reference
  end
end
