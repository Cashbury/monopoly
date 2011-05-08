class RemoveBusinessIdFromEngagementTypes < ActiveRecord::Migration
  def self.up
    remove_column :engagement_types , :business_id
  end

  def self.down
    add_column :engagement_types , :business_id , :integer
  end
end
