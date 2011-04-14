class DropUnnecessarilyFieldsFromRewards < ActiveRecord::Migration
  def self.up
  	remove_column :rewards, :engagement_id
  	remove_column :rewards, :business_id
  	remove_column :rewards, :place_id
  	remove_column :rewards, :product_id
  	remove_column :rewards, :program_id
  	remove_column :rewards, :price
  	remove_column :rewards, :auto_unlock
  end

  def self.down
  	add_column :rewards, :auto_unlock,:boolean
  	add_column :rewards, :price, :decimal,:precision => 10, :scale => 3
  	add_column :rewards, :program_id, :integer
  	add_column :rewards, :product_id, :integer
  	add_column :rewards, :place_id, :integer
  	add_column :rewards, :business_id, :integer
  	add_column :rewards, :engagement_id, :integer
  end
end
