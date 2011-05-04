class RemoveProductIdColumnFromRewards < ActiveRecord::Migration
  def self.up
    remove_column :rewards, :product_id
  end

  def self.down
    add_column :rewards, :product_id, :integer
  end
end
