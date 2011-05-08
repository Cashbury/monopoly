class RenameAccountTypeToPaymentGatewayAtTransactions < ActiveRecord::Migration
  def self.up
    rename_column :transactions, :account_type, :payment_gateway
  end

  def self.down
    rename_column :transactions, :payment_gateway, :account_type
  end
end
