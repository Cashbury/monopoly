class AddProgramIdToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :program_id, :integer
  end

  def self.down
    remove_column :campaigns, :program_id
  end
end
