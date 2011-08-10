class AddIssuedByToLogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :issued_by, :integer
    add_index :logs, :issued_by
  end

  def self.down
    remove_index :logs, :issued_by
    remove_column :logs, :issued_by
  end
end
