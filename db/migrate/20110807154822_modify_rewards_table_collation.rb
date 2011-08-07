class ModifyRewardsTableCollation < ActiveRecord::Migration
  def self.up
    #drop_table :rewards
    create_table :rewards,:options => "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name
      t.decimal :needed_amount
      t.integer :max_claim
      t.date :expiry_date
      t.text :legal_term
      t.integer :campaign_id
      t.integer :max_claim_per_user
      t.boolean :is_active
      t.string :heading1
      t.string :heading2
      t.decimal :sales_price
      t.decimal :offer_price
      t.decimal :cost
      t.string :foreign_identifier
      t.datetime :start_date
      t.string :fb_unlock_msg
      t.string :fb_enjoy_msg
      t.decimal :money_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :rewards
  end
end
