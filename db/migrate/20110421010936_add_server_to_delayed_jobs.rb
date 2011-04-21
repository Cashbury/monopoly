class AddServerToDelayedJobs < ActiveRecord::Migration
  def self.up
    add_column :delayed_jobs, :server, :string
  end

  def self.down
    remove_column :delayed_jobs, :server
  end
end
