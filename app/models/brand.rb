require "#{Rails.root}/lib/paperclip_processors/cropper.rb" # required to make cropping work.
class Brand < ActiveRecord::Base
  belongs_to :user
  has_many :businesses
  has_one :brand_image, :as => :uploadable, :dependent => :destroy
  validates_presence_of :name
  after_update :reprocess_photo
  accepts_nested_attributes_for :brand_image
  private  
  def reprocess_photo  
    if !self.brand_image.nil? and self.brand_image.cropping?
      self.brand_image.photo.reprocess!
      self.brand_image.save
    end
  end  
end
