class AddMailingAddressIdAndBillingAddressIdToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :mailing_address_id, :integer
    add_column :businesses, :billing_address_id, :integer
    remove_column :places, :street_address
  end

  def self.down
    add_column :places, :street_address, :string
    remove_column :businesses, :billing_address_id
    remove_column :businesses, :mailing_address_id
  end
end
