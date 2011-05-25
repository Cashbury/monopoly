class RemoveDescriptionColumnFromRewards < ActiveRecord::Migration
  def self.up
    remove_column :rewards, :description
  end

  def self.down
    add_column :rewards, :description, :string
  end
end
