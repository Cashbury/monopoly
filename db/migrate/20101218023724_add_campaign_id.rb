class AddCampaignId < ActiveRecord::Migration
  def self.up
    add_column :campaigns , :business_id ,:integer
    add_column :rewards , :campaign_id ,:integer
  end

  def self.down
    remove_column :campaigns, :business_id
    remove_column :rewards ,  :campaign_id
  end
end
