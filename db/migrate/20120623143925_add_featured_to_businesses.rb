class AddFeaturedToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :businesses, :featured
  end
end
