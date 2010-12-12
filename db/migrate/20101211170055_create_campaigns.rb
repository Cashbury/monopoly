class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.string :name
      t.string :campaign_type
      t.datetime :expire_at
      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
