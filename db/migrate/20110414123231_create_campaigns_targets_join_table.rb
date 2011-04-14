class CreateCampaignsTargetsJoinTable < ActiveRecord::Migration
  def self.up
  	create_table :campaigns_targets, :id => false do |t|
      t.integer :target_id
      t.integer :campaign_id
      
      t.timestamps
    end
  end

  def self.down
  	drop_table :campaigns_targets
  end
end
