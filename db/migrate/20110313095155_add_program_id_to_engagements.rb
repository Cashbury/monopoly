class AddProgramIdToEngagements < ActiveRecord::Migration
  def self.up
    add_column :engagements, :program_id, :integer
  end

  def self.down
    remove_column :engagements, :program_id
  end
end
