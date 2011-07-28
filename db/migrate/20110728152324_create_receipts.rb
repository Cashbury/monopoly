class CreateReceipts < ActiveRecord::Migration
  def self.up
    create_table :receipts do |t|
      t.integer :business_id
      t.integer :place_id
      t.integer :user_id
      t.string  :receipt_text
      t.integer :amount
      t.string  :receipt_type

      t.timestamps
    end
  end

  def self.down
    drop_table :receipts
  end
end
