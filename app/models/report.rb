class Report < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10
  attr_accessible :name, :type
  
  belongs_to :reportable, :polymorphic => true
  
  belongs_to :engagement
  belongs_to :place
  belongs_to :account
end