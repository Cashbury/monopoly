class AddResonToFlaggins < ActiveRecord::Migration
  def self.up
    add_column :flaggings, :reason, :text

    remove_index :flaggings, :column => [:flag, :flaggable_type, :flaggable_id]
    remove_index :flaggings, :name => "access_flag_flaggings"
    remove_column :flaggings , :flag
  end

  def self.down
    add_column :flaggings, :flag , :string
    add_index :flaggings, [:flag, :flaggable_type, :flaggable_id]
    add_index :flaggings, [:flag, :flagger_type, :flagger_id, :flaggable_type, :flaggable_id], :name => "access_flag_flaggings"

    remove_column :flaggings, :reason
  end
end
