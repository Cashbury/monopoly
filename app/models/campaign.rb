class Campaign < ActiveRecord::Base
  attr_accessible :name, :action, :expire_at
end
