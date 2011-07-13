class ChangeDefaultColumnIsActiveRewards < ActiveRecord::Migration
  def self.up
    change_column_default(:rewards,:is_active,true)
  end

  def self.down
    change_column_default(:rewards,:is_active,false)
  end
end
