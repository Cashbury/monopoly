class Newsletter < ActiveRecord::Base
    attr_accessible :letter_type, :name, :email
end
