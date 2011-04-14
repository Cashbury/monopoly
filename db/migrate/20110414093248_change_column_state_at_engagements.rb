class ChangeColumnStateAtEngagements < ActiveRecord::Migration
  def self.up
  	Engagement.update_all(:state=>:null)
  	change_column :engagements, :state, :boolean, :default=>true
  	Engagement.update_all(:state=>true)
  end

  def self.down
  	change_column :engagements, :state, :string
  end
end
