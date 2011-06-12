class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name
      t.string :photo
      t.boolean :active
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :templates
  end
end
