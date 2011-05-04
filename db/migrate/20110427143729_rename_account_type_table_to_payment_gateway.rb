class RenameAccountTypeTableToPaymentGateway < ActiveRecord::Migration
  def self.up
    rename_table :account_types, :payment_gateways
    add_column :accounts, :payment_gateway_id, :integer
  end

  def self.down
    remove_column :accounts, :payment_gateway_id
    rename_table :payment_gateways, :account_types
  end
end
