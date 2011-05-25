class ModifyCampaignsPlacesAndCampaignTargets < ActiveRecord::Migration
  def self.up
    remove_column :campaigns_places, :created_at
    remove_column :campaigns_places, :updated_at
    remove_column :campaigns_targets, :created_at
    remove_column :campaigns_targets, :updated_at
  end

  def self.down
    add_column :campaigns_targets, :created_at, :datetime
    add_column :campaigns_targets, :updated_at, :datetime
    add_column :campaigns_places, :updated_at, :datetime
    add_column :campaigns_places, :created_at, :datetime
  end
end
