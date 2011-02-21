class CreateNewsletters < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table :newsletters
    remove_index :newsletters , :email
  end
end
