class AddResonToFlaggins < ActiveRecord::Migration
  def self.up
    add_column :flaggins, :reason, :text
  end

  def self.down
    remove_column :flaggins, :reason
  end
end
