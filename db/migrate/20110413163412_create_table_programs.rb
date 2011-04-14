class CreateTablePrograms < ActiveRecord::Migration
  def self.up
  	create_table :programs do |t|
			t.integer :program_type_id
			t.integer :business_id
			
      t.timestamps
    end
  end

  def self.down
  	drop_table :programs
  end
end
