class CreatePrintJobs < ActiveRecord::Migration
  def self.up
    create_table :print_jobs do |t|
      t.string :name
      t.integer :ran
      t.text :log

      t.timestamps
    end
  end

  def self.down
    drop_table :print_jobs
  end
end
