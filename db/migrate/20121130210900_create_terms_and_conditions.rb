class CreateTermsAndConditions < ActiveRecord::Migration
  def self.up
    create_table :terms_and_conditions do |t|
      t.text :description

      t.timestamps
    end

    create_table :accepted_terms, id: false do |t|
      t.references :user
      t.references :term_and_condition
      t.timestamps
    end

    add_index :accepted_terms, :user_id
    add_index :accepted_terms, :term_and_condition_id
    add_index :accepted_terms, [:user_id, :term_and_condition_id]
  end

  def self.down
    drop_table :accepted_terms
    drop_table :terms_and_conditions
  end
end
