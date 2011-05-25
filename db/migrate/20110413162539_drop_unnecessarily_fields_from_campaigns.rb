class DropUnnecessarilyFieldsFromCampaigns < ActiveRecord::Migration
  def self.up
  	remove_column :campaigns, :program_type_id
  	remove_column :campaigns, :business_id
  	remove_column :campaigns, :auto_enroll
  	remove_column :campaigns, :max_points
  end

  def self.down
  	add_column :campaigns, :max_points, :integer
  	add_column :campaigns, :auto_enroll, :boolean
  	add_column :campaigns, :business_id, :integer
  	add_column :campaigns, :program_type_id, :integer
  end
end
