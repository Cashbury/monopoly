class UsersModification < ActiveRecord::Migration
  def self.up
    rename_column :users, :full_name, :first_name
    add_column :users, :last_name, :string
    add_column :users, :telephone_number, :string
    add_column :users, :username, :string
    add_column :users, :mailing_address_id, :integer
    add_column :users, :billing_address_id, :integer
    add_column :users, :is_fb_account, :boolean
    add_column :users, :note, :text
    add_column :users, :home_town, :string
    add_column :users, :language_of_preference, :string
    add_column :users, :default_currency, :string
    add_column :users, :timezone, :string
  end

  def self.down
    remove_column :users, :timezone
    remove_column :users, :default_currency
    remove_column :users, :language_of_preference
    remove_column :users, :home_town
    remove_column :users, :note
    remove_column :users, :is_fb_account
    remove_column :users, :username
    remove_column :users, :telephone_number
    remove_column :users, :last_name
    rename_column :users, :first_name, :full_name   
  end
end
