class CreateNeighborhood < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.string :name
      t.boolean :approved
    end
    add_index :countries, :name
  end

  def self.down
    drop_table :neighborhoods
  end
end
