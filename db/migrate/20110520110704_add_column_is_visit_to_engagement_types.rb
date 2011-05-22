class AddColumnIsVisitToEngagementTypes < ActiveRecord::Migration
  def self.up
    add_column :engagement_types, :is_visit, :boolean
  end

  def self.down
    remove_column :engagement_types, :is_visit
  end
end
