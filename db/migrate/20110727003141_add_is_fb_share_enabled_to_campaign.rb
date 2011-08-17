class AddIsFbShareEnabledToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :is_fb_enabled, :boolean ,:default => true
  end

  def self.down
    remove_column :campaigns, :is_fb_enabled
  end
end
