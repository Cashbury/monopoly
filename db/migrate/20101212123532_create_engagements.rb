class CreateEngagements < ActiveRecord::Migration
  def self.up
    create_table :engagements do |t|
      t.string :engagement_type
      t.string :stamp
      t.integer :campaign_id
      t.timestamps
    end
  end

  def self.down
    drop_table :engagements
  end
end
