class AddProgramIdAndBusinessIdIntoAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :program_id , :integer
    add_column :accounts, :business_id , :integer
  end

  def self.down
    remove_column :accounts, :business_id
    remove_column :accounts, :program_id
  end
end
