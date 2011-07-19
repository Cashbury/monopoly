class AddFieldsToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :ctype, :integer
    add_column :campaigns, :amount_in_points, :decimal, :precision => 20, :scale => 3
  end

  def self.down
    remove_column :campaigns, :amount_in_points
    remove_column :campaigns, :ctype
  end
end
