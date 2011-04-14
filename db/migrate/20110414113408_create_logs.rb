class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :user_id
      t.integer :reward_id
      t.string  :log_type
      t.boolean :is_processed
      t.integer :place_id
      t.integer :engagement_id
      t.integer :business_id
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.string  :currency
      t.decimal :amount, :precision => 20, :scale => 3
      t.integer :frequency
      t.string  :amount_type
      t.date    :created_on
			t.integer :log_group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
