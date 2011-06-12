class CreateRewards < ActiveRecord::Migration
  def self.up
    create_table :rewards do |t|
      t.string :name
      t.integer :engagement_id
      t.timestamps
    end
  end

  def self.down
    drop_table :rewards
  end
end
