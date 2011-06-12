class RemoveBusinessIdFromFollowers < ActiveRecord::Migration
  def self.up
    remove_column :followers, :business_id
    add_column :followers, :followed_id, :integer
    add_column :followers, :followed_type, :string
  end

  def self.down
    remove_column :followers, :followed_type
    remove_column :followers, :followed_id
    add_column :followers, :business_id, :integer
  end
end
