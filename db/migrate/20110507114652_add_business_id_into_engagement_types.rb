class AddBusinessIdIntoEngagementTypes < ActiveRecord::Migration
  def self.up
    add_column :engagement_types , :business_id , :integer
  end

  def self.down
    remove_column :engagement_types , :business_id
  end
end
