class CreateLegalTypes < ActiveRecord::Migration
  def self.up
    create_table :legal_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :legal_types
  end
end
