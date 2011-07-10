class CreateLoginMethods < ActiveRecord::Migration
  def self.up
    create_table :login_methods do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :login_methods
  end
end
