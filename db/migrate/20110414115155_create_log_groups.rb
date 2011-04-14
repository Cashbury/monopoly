class CreateLogGroups < ActiveRecord::Migration
  def self.up
    create_table :log_groups do |t|
      t.date :created_on

      t.timestamps
    end
  end

  def self.down
    drop_table :log_groups
  end
end
