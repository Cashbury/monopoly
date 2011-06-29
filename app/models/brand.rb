require "#{Rails.root}/lib/paperclip_processors/cropper.rb" # required to make cropping work.
# == Schema Information
# Schema version: 20110615133925
#
# Table name: brands
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#
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
