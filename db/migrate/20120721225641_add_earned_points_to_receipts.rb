class AddEarnedPointsToReceipts < ActiveRecord::Migration
  def self.up
    add_column :receipts, :earned_points, :decimal, :precision => 20, :scale => 3, :default => 0
  end

  def self.down
    remove_column :receipts, :earned_points
  end
end
