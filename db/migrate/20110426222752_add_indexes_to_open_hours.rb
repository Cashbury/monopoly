class AddIndexesToOpenHours < ActiveRecord::Migration
  def self.up
    add_index :open_hours,[:day_no,:from,:to]
  end

  def self.down
    remove_index :open_hours,[:day_no,:from,:to]
  end
end
