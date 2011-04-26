class AddProductIdToReward < ActiveRecord::Migration
  def self.up
    add_column :rewards, :product_id, :integer
  end

  def self.down
    remove_column :rewards, :product_id
  end
end
