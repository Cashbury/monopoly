class AddNameToEngagement < ActiveRecord::Migration
  def self.up
    add_column :engagements , :name, :string, :length=>50
  end

  def self.down
    remove_column :engagements, :name
  end
end
