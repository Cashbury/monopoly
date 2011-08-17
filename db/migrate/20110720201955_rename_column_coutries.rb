class RenameColumnCoutries < ActiveRecord::Migration
  def self.up
    rename_column :countries , :country_code, :phone_country_code
    rename_column :cities    , :area_code,    :phone_area_code
  end

  def self.down
    rename_column :countries ,  :phone_country_code, :country_code
    rename_column :cities    ,  :phone_area_code,    :area_code
  end
end
