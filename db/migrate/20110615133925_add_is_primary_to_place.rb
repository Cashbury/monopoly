class AddIsPrimaryToPlace < ActiveRecord::Migration
  def self.up
    add_column :places,     :is_primary,  :boolean , :default => false
    add_column :businesses, :legal_id,    :string
  end

  def self.down
    remove_column :places, :is_primary
    remove_column :businesses, :legal_id
  end
end
