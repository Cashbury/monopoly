class CreateLegalIds < ActiveRecord::Migration
  def self.up
    create_table :legal_ids do |t|
      t.integer :id_number
      t.integer :legal_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :legal_ids
  end
end
