class CreateAccountHolders < ActiveRecord::Migration
  def self.up
    create_table :account_holders do |t|
      t.string :model_type
      t.integer :model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :account_holders
  end
end
