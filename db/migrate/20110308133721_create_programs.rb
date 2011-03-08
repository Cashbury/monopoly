class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.string 	:name,:null=>false
      t.integer :type_id,:null=>false
      t.boolean :auto_enroll
      t.date 		:start_date
      t.date 		:end_date
      t.integer :business_id,:null=>false
      t.integer :initial_points,:default=>0
      t.integer :max_points,:default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :programs
  end
end
