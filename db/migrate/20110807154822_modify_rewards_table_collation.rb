class ModifyRewardsTableCollation < ActiveRecord::Migration
  def self.up
    drop_table :rewards
    create_table :rewards,:options => "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name
      t.decimal :needed_amount, :precision => 10, :scale => 0
      t.integer :max_claim, :default=>0
      t.date :expiry_date
      t.text :legal_term
      t.integer :campaign_id
      t.integer :max_claim_per_user, :default=>0
      t.boolean :is_active, :default=>true
      t.string :heading1
      t.string :heading2
      t.decimal :sales_price, :precision => 20, :scale => 3
      t.decimal :offer_price, :precision => 20, :scale => 3
      t.decimal :cost, :precision => 20, :scale => 3
      t.string :foreign_identifier
      t.datetime :start_date
      t.string :fb_unlock_msg
      t.string :fb_enjoy_msg
      t.decimal :money_amount, :precision => 20, :scale => 3

      t.timestamps
    end
  end

  def self.down
    drop_table :rewards
    create_table :rewards do |t|
      t.string :name
      t.decimal :needed_amount, :precision => 10, :scale => 0
      t.integer :max_claim, :default=>0
      t.date :expiry_date
      t.text :legal_term
      t.integer :campaign_id
      t.integer :max_claim_per_user, :default=>0
      t.boolean :is_active, :default=>true
      t.string :heading1
      t.string :heading2
      t.decimal :sales_price, :precision => 20, :scale => 3
      t.decimal :offer_price, :precision => 20, :scale => 3
      t.decimal :cost, :precision => 20, :scale => 3
      t.string :foreign_identifier
      t.datetime :start_date
      t.string :fb_unlock_msg
      t.string :fb_enjoy_msg
      t.decimal :money_amount, :precision => 20, :scale => 3

      t.timestamps
    end
  end
end
