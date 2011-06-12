class AddFieldsToEngagements < ActiveRecord::Migration
  def self.up
  	add_column :engagements, :amount, :decimal, :precision => 20, :scale => 3
  	add_column :engagements, :campaign_id, :integer
  	add_column :engagements, :engagement_type_id, :integer
  	    
  end

  def self.down
  	remove_column :engagements, :engagement_type_id
  	remove_column :engagements, :campaign_id
  	remove_column :engagements, :amount
  end
end
