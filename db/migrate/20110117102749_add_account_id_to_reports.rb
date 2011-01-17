class AddAccountIdToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :account_id, :integer
  end

  def self.down
    remove_column :reports, :account_id
  end
end
