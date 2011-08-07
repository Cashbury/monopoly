class ModifyRewardsTableCollation < ActiveRecord::Migration
  def self.up
    drop_table :rewards
  end

  def self.down
    create_table :rewards,:options => "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name
      t.needed_amount :decimal
      t.max_claim :integer
      t.expiry_date :date
      t.legal_term :text
      t.campaign_id :integer
      t.max_claim_per_user :integer
      t.is_active :boolean
      t.heading1 :string
      t.heading2 :text
      t.sales_price :decimal, :precision=> 20, :scale=>3
      t.offer_price :decimal, :precision=> 20, :scale=>3
      t.cost :decimal, :precision=> 20, :scale=>3
      t.foreign_identifier :string
      t.start_date :datetime
      t.fb_unlock_msg :string
      t.fb_enjoy_msg :string
      t.money_amount :decimal, :precision=> 20, :scale=>3

      t.timestamps
    end
  end
end
