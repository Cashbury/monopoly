class AddStartDateIntoRawards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :start_date , :datetime
  end

  def self.down
    remove_column :rewards, :start_date
  end
end
