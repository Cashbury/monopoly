class AddLegalTermsToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards, :legal_term, :text
  end

  def self.down
    remove_column :rewards, :legal_term
  end
end
