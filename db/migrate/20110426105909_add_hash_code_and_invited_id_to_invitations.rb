class AddHashCodeAndInvitedIdToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :hash_code, :string
    add_column :invitations, :to_user_id, :integer
  end

  def self.down
    remove_column :invitations, :to_user_id
    remove_column :invitations, :hash_code
  end
end
