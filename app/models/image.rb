class Image < ActiveRecord::Base
  belongs_to :uploadable, :polymorphic => true
end
