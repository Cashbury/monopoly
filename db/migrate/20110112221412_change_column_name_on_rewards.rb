class ChangeColumnNameOnRewards < ActiveRecord::Migration
  def self.up
    rename_column :rewards, :availabled, :available
    Reward.reset_column_information
    change_column :rewards, :available, :datetime
  end

  def self.down
  end
end
