class AddTitleTagToTemplates < ActiveRecord::Migration
  def self.up
    add_column :templates, :title, :string
    add_column :templates, :tag, :string
  end

  def self.down
    remove_column :templates, :tag
    remove_column :templates, :title
  end
end
