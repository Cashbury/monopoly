class AddSignUpCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sign_up_count, :integer , :default =>0
  end

  def self.down
    remove_column :users, :sign_up_count
  end
end
