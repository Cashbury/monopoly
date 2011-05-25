class RenamePointsToNeededAmountFromRewards < ActiveRecord::Migration
  def self.up
  	rename_column :rewards , :points , :needed_amount
  	change_column :rewards, :needed_amount, :decimal
  end

  def self.down
  	change_column :rewards, :needed_amount, :integer
  	rename_column :rewards , :needed_amount  , :points
  end
end
