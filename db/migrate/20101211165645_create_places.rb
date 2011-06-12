class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name
      t.string :long
      t.string :lat
      t.integer :business_id
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
