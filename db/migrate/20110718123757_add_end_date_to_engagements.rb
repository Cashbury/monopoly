class AddEndDateToEngagements < ActiveRecord::Migration
  def self.up
    add_column :engagements, :end_date, :date
  end

  def self.down
    remove_column :engagements, :end_date
  end
end
