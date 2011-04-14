class CreateMeasurementTypesTable < ActiveRecord::Migration
  def self.up
  	create_table :measurement_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
  	drop_table :measurement_types
  end
end
