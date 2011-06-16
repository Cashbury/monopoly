class AddPrimaryUserFieldsToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :principal_user_id,   :integer
    add_column :businesses, :principal_legal_id,  :string
    add_column :businesses, :principal_address_id,  :integer
    add_column :businesses, :is_esigned,          :boolean
  end

  def self.down
    remove_column :businesses, :is_esigned
    remove_column :businesses, :principal_address_id
    remove_column :businesses, :principal_legal_id
    remove_column :businesses, :principal_user_id
  end
end
