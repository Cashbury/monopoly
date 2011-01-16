class Report < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10
  attr_accessible :name, :type
  belongs_to :reportable, :polymorphic => true
end
