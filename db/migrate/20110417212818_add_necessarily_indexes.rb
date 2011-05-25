class AddNecessarilyIndexes < ActiveRecord::Migration
  def self.up
    add_index :businesses, :brand_id
    add_index :places, :business_id
    add_index :places, :name
    add_index :programs, :business_id
    add_index :programs, :program_type_id
    add_index :campaigns, :program_id
    add_index :campaigns, :measurement_type_id
    add_index :engagements, :campaign_id
    add_index :engagements, :engagement_type_id
    add_index :rewards, :campaign_id
    add_index :logs, :user_id
    add_index :logs, :log_type
    add_index :logs, [:user_id,:reward_id,:log_type]
    add_index :accounts, :account_holder_id
    add_index :accounts, :campaign_id
    add_index :account_holders,[:model_type,:model_id]
    add_index :qr_codes, [:related_type,:hash_code]
  end

  def self.down
    remove_index :qr_codes, [:related_type,:hash_code]
    remove_index :account_holders,[:model_type,:model_id]
    remove_index :accounts, :campaign_id
    remove_index :accounts, :account_holder_id
    remove_index :logs, [:user_id,:reward_id,:log_type]
    remove_index :logs, :log_type
    remove_index :logs, :user_id
    remove_index :rewards, :campaign_id
    remove_index :engagements, :engagement_type_id
    remove_index :engagements, :campaign_id
    remove_index :campaigns, :measurement_type_id
    remove_index :campaigns, :program_id
    remove_index :programs, :program_type_id
    remove_index :programs, :business_id
    remove_index :places, :name
    remove_index :places, :business_id
    remove_index :businesses, :brand_id
  end
end
