class AddBusinessesCategoriesJointTable < ActiveRecord::Migration
  def self.up
    create_table :businesses_categories, :id => false do |t|
      t.integer :business_id, :category_id
    end
  end

  def self.down
    drop_table :categories
  end
end
