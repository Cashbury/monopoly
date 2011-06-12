class AddInitialBizAmountColumnToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :initial_biz_amount, :decimal, :precision=>20, :scale=>3
    change_table :campaigns do |t|
      t.change :initial_amount, :decimal, :precision=>20, :scale=>3
    end
  end

  def self.down
    change_table :campaigns do |t|
      t.change :initial_amount, :integer
    end
    remove_column :campaigns, :initial_biz_amount
  end
end
