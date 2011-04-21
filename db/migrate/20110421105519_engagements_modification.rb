class EngagementsModification < ActiveRecord::Migration
  def self.up
    rename_column :engagements, :state, :is_started
    add_index :engagements, :is_started
    drop_table :engagements_places
  end

  def self.down
    remove_index :engagements, :is_started
    rename_column :engagements, :is_started, :state
    create_table "engagements_places", :id => false, :force => true do |t|
      t.integer "engagement_id"
      t.integer "place_id"
    end
  end
end
