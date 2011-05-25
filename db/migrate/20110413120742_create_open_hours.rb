class CreateOpenHours < ActiveRecord::Migration
  def self.up
    create_table :open_hours do |t|
      t.integer  :day_no
      t.datetime :from
      t.datetime :to
			t.integer  :place_id
			
      t.timestamps
    end
  end

  def self.down
    drop_table :open_hours
  end
end
