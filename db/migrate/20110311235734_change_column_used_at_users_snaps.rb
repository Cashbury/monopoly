class ChangeColumnUsedAtUsersSnaps < ActiveRecord::Migration
  def self.up
  	change_column :users_snaps, :used_at, :date
  end

  def self.down
  	change_column :users_snaps, :used_at, :datetime
  end
end
