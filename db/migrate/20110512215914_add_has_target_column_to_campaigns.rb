class AddHasTargetColumnToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :has_target, :boolean
  end

  def self.down
    remove_column :campaigns, :has_target
  end
end
