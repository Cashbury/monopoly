class AddMailingAddressIdAndBillingAddressIdToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :mailing_address_id, :integer
    add_column :businesses, :billing_address_id, :integer
  end

  def self.down
    remove_column :businesses, :billing_address_id
    remove_column :businesses, :mailing_address_id
  end
end
