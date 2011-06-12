class RenameTypeIdAtProgram < ActiveRecord::Migration
  def self.up
  	rename_column :programs, :type_id, :program_type_id
  end

  def self.down
  	rename_column :programs, :program_type_id, :type_id
  end
end
