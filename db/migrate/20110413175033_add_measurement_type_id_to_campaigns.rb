class AddMeasurementTypeIdToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :measurement_type_id, :integer
  end

  def self.down
    remove_column :campaigns, :measurement_type_id
  end
end
