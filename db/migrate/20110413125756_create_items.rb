class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string  :name
      t.string  :description
      t.decimal :price,:precision => 10, :scale => 3
      t.integer :business_id
      t.string  :photo
      t.boolean :available
      t.date    :expiry_date

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
