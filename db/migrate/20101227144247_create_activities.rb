class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.references :user
      t.references :engagement
      t.references :place
      t.integer :points
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
