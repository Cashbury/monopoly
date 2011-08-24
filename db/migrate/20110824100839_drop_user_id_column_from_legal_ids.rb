class DropUserIdColumnFromLegalIds < ActiveRecord::Migration
  def self.up
    remove_column :legal_ids, :user_id
  end

  def self.down
    add_column :legal_ids, :user_id, :integer
  end
end
