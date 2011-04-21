class RenameInitialPointsAtCampaigns < ActiveRecord::Migration
  def self.up
    rename_column :campaigns,:initial_points, :initial_amount
  end

  def self.down
    rename_column :campaigns,:initial_amount, :initial_points
  end
end
