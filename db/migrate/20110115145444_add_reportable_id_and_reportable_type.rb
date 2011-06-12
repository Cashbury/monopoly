class AddReportableIdAndReportableType < ActiveRecord::Migration
  def self.up
    add_column :reports, :reportable_id, :integer
    add_column :reports, :reportable_type, :string
  end

  def self.down
    remove_column :reports, :reportable_id
    remove_column :reports, :reportable_type
  end
end