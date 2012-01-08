class CreateUsersProgramsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :users_programs, :id => false do |t|
      t.belongs_to :user
      t.belongs_to :program
    end
  end

  def self.down
    drop_table :users_programs
  end
end
