class CreateAddressProfiles < ActiveRecord::Migration
  def self.up
    create_table :address_profiles do |t|
      t.string :format

      t.timestamps
    end
  end

  def self.down
    drop_table :address_profiles
  end
end
