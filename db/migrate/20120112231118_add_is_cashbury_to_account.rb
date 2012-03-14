class AddIsCashburyToAccount < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.boolean :is_cashbury, :default => false
    end
  end

  def self.down
    change_table :accounts do |t|
      t.remove :is_cashbury
    end
  end
end
