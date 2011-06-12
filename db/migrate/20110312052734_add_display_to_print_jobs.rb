class AddDisplayToPrintJobs < ActiveRecord::Migration
  def self.up
    add_column :print_jobs, :display, :boolean
  end

  def self.down
    remove_column :print_jobs, :display
  end
end
