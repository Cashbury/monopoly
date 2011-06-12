class AddProgramIdToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :program_id, :integer
  end

  def self.down
    remove_column :accounts, :program_id
  end
end
