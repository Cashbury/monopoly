class ModifyEngagementTypesTable < ActiveRecord::Migration
  def self.up
    engagement_types=EngagementType.all
    add_column :engagement_types, :eng_type, :integer
    engagement_types.each do |eng_type|
      if eng_type.has_item
        eng_type.update_attribute(:eng_type,EngagementType::ENG_TYPE[:buy])
      elsif eng_type.is_visit
        eng_type.update_attribute(:eng_type,EngagementType::ENG_TYPE[:visit])
      end
    end
    remove_column :engagement_types, :has_item
    remove_column :engagement_types, :is_visit
  end

  def self.down
    add_column :engagement_types, :is_visit, :boolean
    add_column :engagement_types, :has_item, :boolean
    remove_column :engagement_types, :eng_type
  end
end
