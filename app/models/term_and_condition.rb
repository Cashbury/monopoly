class TermAndCondition < ActiveRecord::Base
  set_table_name :terms_and_conditions

  validates :description, presence: true
end
