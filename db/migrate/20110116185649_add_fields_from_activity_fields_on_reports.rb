class AddFieldsFromActivityFieldsOnReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :user_id, :integer
    add_column :reports, :engagement_id, :integer
    add_column :reports, :place_id, :integer
    add_column :reports, :points, :string
  end

  def self.down
    remove_column :reports, :user_id
    remove_column :reports, :engagement_id
    remove_column :reports, :place_id
    remove_column :reports, :points
  end
end
