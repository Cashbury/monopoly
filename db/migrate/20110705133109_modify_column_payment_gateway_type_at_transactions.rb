class ModifyColumnPaymentGatewayTypeAtTransactions < ActiveRecord::Migration
  def self.up
    rename_column :transactions, :payment_gateway, :payment_gateway_id
    change_table :transactions do |t|
      t.change :payment_gateway_id, :integer
    end
  end

  def self.down
    change_table :transactions do |t|
      t.change :payment_gateway_id, :string
    end
    rename_column :transactions, :payment_gateway_id, :payment_gateway
  end
end
