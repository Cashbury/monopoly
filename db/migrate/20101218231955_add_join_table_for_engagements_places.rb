class AddJoinTableForEngagementsPlaces < ActiveRecord::Migration
  def self.up
  create_table :engagements_places, :id=>false do |t|
        t.integer :engagement_id
        t.integer :place_id
      end

  end

  def self.down
    drop_table :engagements_places
  end
end
