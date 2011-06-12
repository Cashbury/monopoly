class AddBrandReferenceToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :brand_id, :integer
  end

  def self.down
    remove_column :businesses, :brand_id
  end
end
