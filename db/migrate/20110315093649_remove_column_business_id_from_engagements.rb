class RemoveColumnBusinessIdFromEngagements < ActiveRecord::Migration
  def self.up
  	remove_column :engagements, :business_id
  end

  def self.down
  	add_column :engagements, :business_id, :integer
  end
end
