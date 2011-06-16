class AddPrimaryUserFieldsToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :principal_user_id,   :integer
    add_column :businesses, :legal_id  ,           :integer
  end

  def self.down
    remove_column :businesses, :legal_id
    remove_column :businesses, :principal_user_id
  end
end
