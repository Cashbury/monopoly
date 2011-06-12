class RemoveUnnecessaryFieldsOnReports < ActiveRecord::Migration
  def self.up
    remove_column :reports, :type
    remove_column :reports, :user_id
    add_column :reports, :activity_type, :string
  end

  def self.down
    add_column :reports, :type, :string
    add_column :reports, :user_id, :integer
    remove_column :reports, :activity_type
  end
end
