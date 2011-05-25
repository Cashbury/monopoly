class ChangeColumnAvalibleDefaultInItems < ActiveRecord::Migration
  def self.up
    change_column_default(:items, :available, true)
  end

  def self.down
    change_column_default(:items, :available, nil)
  end
end
