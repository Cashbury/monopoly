class AddColumnProgramIdToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :program_id, :integer
  end

  def self.down
    remove_column :rewards, :program_id
  end
end
