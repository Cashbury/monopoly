class ChangeColumnTypeFromAndToFromOpenHours < ActiveRecord::Migration
  def self.up
    change_table :open_hours do |t|
      t.change :from, :time
      t.change :to, :time
    end
  end

  def self.down
    change_table :open_hours do |t|
      t.change :from, :datetime
      t.change :to, :datetime
    end
  end
end
