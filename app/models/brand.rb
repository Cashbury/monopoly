class Brand < ActiveRecord::Base
  belongs_to :user
  has_many :businesses
  has_one :brand_image, :as => :uploadable, :dependent => :destroy
  
  validates_presence_of :name
end
