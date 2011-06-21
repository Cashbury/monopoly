class AddDobToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :dob,              :date
    add_column :users, :is_terms_agreed,  :boolean
  end

  def self.down
    remove_column :users, :is_terms_agreed
    remove_column :users, :dob
  end
end
