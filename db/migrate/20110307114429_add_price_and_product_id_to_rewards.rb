class AddPriceAndProductIdToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :price, :decimal
    add_column :rewards, :product_id, :string
  end

  def self.down
    remove_column :rewards, :product_id
    remove_column :rewards, :price
  end
end
