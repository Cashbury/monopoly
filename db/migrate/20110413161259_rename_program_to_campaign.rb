class RenameProgramToCampaign < ActiveRecord::Migration
  def self.up
  	rename_table :programs, :campaigns
  end

  def self.down
  	rename_table :campaigns, :programs
  end
end
