class AddClaimAvailabledToRewads < ActiveRecord::Migration
  def self.up
    add_column :rewards, :claim, :integer
    add_column :rewards, :availabled, :date
  end

  def self.down
    remove_column :rewards, :availabled
    remove_column :rewards, :claim
  end
end
