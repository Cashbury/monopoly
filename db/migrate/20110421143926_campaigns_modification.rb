class CampaignsModification < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :state, :string
  end

  def self.down
    remove_column :campaigns, :state
  end
end
