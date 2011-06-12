class CreateEngagements < ActiveRecord::Migration
  def self.up
    create_table :engagements do |t|
      t.string :engagement_type
      t.string :points
      t.string :state
      t.string :description
      t.integer :campaign_id
      t.timestamps
    end
  end

  def self.down
    drop_table :engagements
  end
end
