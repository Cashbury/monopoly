class DropTableReports < ActiveRecord::Migration
  def self.up
    drop_table :reports
  end

  def self.down
    create_table "reports", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "reportable_id"
      t.string   "reportable_type"
      t.integer  "engagement_id"
      t.integer  "place_id"
      t.string   "points"
      t.string   "activity_type"
      t.integer  "account_id"
    end
  end
end
