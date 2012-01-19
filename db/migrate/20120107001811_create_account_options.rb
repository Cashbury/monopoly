class CreateAccountOptions < ActiveRecord::Migration
  def self.up
    create_table :account_options do |t|
      t.belongs_to :account, :null => false
      t.integer :max_daily_load_limit
      t.integer :max_daily_spend_limit
      t.timestamps
    end
  end

  def self.down
    drop_table :account_options
  end
end
