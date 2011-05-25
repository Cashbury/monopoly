class AddAssociatableIdAndAssociatableTypeIntoLegalIds < ActiveRecord::Migration
  def self.up
    add_column :legal_ids , :associatable_id, :integer # associated_id could be link to user or business
    add_column :legal_ids , :associatable_type, :string # associated_type will be the name of the model we enetered its if in associated_id feild.
  end

  def self.down
    remove_column :legal_ids , :associatable_type
    remove_column :legal_ids , :associatable_id
  end
end
