class AddIsFbEnabledToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_fb_enabled, :boolean ,:default=>true
  end

  def self.down
    remove_column :users, :is_fb_enabled
  end
end
