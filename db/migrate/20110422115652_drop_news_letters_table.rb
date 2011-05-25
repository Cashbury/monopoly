class DropNewsLettersTable < ActiveRecord::Migration
  def self.up
    remove_index :newsletters , :email
    drop_table :newsletters
  end
  
  def self.down
    create_table :newsletters do |t|
      t.boolean :letter_type
      t.string :name
      t.string :city
      t.string :country
      t.string :email
      t.timestamps
    end
    add_index :newsletters , :email , :unique =>true
  end
end
