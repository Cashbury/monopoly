class CreateEngagementTypes < ActiveRecord::Migration
  def self.up
    create_table :engagement_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :engagement_types
  end
end
