class RemoveCountryIdColumnFromAddresses < ActiveRecord::Migration
  def self.up
    remove_column :addresses, :country_id
  end

  def self.down
    add_column :addresses, :country_id, :integer
  end
end
