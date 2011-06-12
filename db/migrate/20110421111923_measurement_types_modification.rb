class MeasurementTypesModification < ActiveRecord::Migration
  def self.up
    add_column :measurement_types, :business_id, :integer
    add_index :measurement_types, :business_id
  end

  def self.down
    remove_index :measurement_types, :business_id
    remove_column :measurement_types, :business_id
  end
end
