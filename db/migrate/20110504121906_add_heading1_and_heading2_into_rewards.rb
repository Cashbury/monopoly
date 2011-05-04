class AddHeading1AndHeading2IntoRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards , :heading1 , :text
    add_column :rewards , :heading2 , :text
  end

  def self.down
    remove_column :rewards , :heading2
    remove_column :rewards , :heading1
  end
end
