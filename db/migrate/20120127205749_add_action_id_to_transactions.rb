class AddActionIdToTransactions < ActiveRecord::Migration
  def self.up
    change_table :transactions do |t|
      t.belongs_to :action
    end
  end

  def self.down
    change_table :transactions do |t|
      t.remove_belongs_to :action
    end
  end
end
