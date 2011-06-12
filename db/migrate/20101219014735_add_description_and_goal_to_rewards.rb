class AddDescriptionAndGoalToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards , :description ,:text 
    add_column :rewards , :points ,:integer
  end

  def self.down
    remove_column :rewards , :description 
    remove_column :rewards , :points
  end
end
