class AddBusinessNameAndCityToFollowers < ActiveRecord::Migration
  def self.up
    add_column :followers, :biz_name, :string
    add_column :followers, :city, :string
  end

  def self.down
    remove_column :followers, :city
    remove_column :followers, :biz_name
  end
end
