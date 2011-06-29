class AddFbEngagementMsgToEngagementsTable < ActiveRecord::Migration
  def self.up
    add_column :engagements, :fb_engagement_msg, :string
  end

  def self.down
    remove_column :engagements, :fb_engagement_msg
  end
end
