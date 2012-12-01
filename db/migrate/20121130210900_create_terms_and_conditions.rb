class CreateTermsAndConditions < ActiveRecord::Migration
  def self.up
    create_table :terms_and_conditions do |t|
      t.text :description

      t.timestamps
    end

  end

  def self.down
    drop_table :terms_and_conditions
  end
end
