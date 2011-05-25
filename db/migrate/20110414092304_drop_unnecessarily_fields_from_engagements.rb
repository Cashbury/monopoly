class DropUnnecessarilyFieldsFromEngagements < ActiveRecord::Migration
  def self.up
  	remove_column :engagements, :engagement_type
  	remove_column :engagements, :points
  	remove_column :engagements, :place_id
  	remove_column :engagements, :program_id
  	remove_column :engagements, :reward_id
  end

  def self.down
  	add_column :engagements, :reward_id, :integer
  	add_column :engagements, :program_id, :integer
  	add_column :engagements, :place_id, :integer
  	add_column :engagements, :points, :string
  	add_column :engagements, :engagement_type, :string
  end
end
