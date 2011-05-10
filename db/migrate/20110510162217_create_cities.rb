class CreateCities < ActiveRecord::Migration
  def self.up 
    create_table :cities do |t|
      t.integer :country_id
      t.string  :name
    end
    
    add_index :cities, :name
    add_index :cities, :country_id
  end
  
  def self.down
    drop_table :cities
  end
  
end