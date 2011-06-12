class AddPhoneColumnToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :phone, :string
  end

  def self.down
    remove_column :places, :phone
  end
end
