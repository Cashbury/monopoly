class ProgramsModification < ActiveRecord::Migration
  def self.up
    add_column :programs, :name, :string
    add_column :programs, :is_started, :boolean
  end

  def self.down
    remove_column :programs, :is_started
    remove_column :programs, :name
  end
end
