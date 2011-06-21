class Role < ActiveRecord::Base
  attr_accessible :name

  AS = {
    :principal  =>"owner",
    :super_admin=>"super_admin",
    :admin      =>"admin",
    :mobi       => "mobi"
  }

  has_and_belongs_to_many :users
end
