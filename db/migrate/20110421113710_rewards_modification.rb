class RewardsModification < ActiveRecord::Migration
  def self.up
    rename_column :rewards, :claim, :max_claim
    change_table :rewards do |t|
      t.change :max_claim, :integer, :default=>0
    end
    add_column :rewards, :max_claim_per_user, :integer,:default=>0
    add_column :rewards, :is_active, :boolean
    rename_column :rewards, :available, :expiry_date
    remove_column :targets_users, :created_at
    remove_column :targets_users, :updated_at
  end

  def self.down
    add_column :targets_users, :created_at, :datetime
    add_column :targets_users, :updated_at, :datetime
    rename_column :rewards, :expiry_date, :available
    remove_column :rewards, :is_active
    remove_column :rewards, :max_claim_per_user 
    change_table :rewards do |t|
      t.change :max_claim, :integer
    end
    rename_column :rewards, :max_claim, :claim 
  end
end
