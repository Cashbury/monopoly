class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :targets do |t|
      t.string :name
      t.string :description
      t.integer :business_id

      t.timestamps
    end
  end

  def self.down
    drop_table :targets
  end
end
