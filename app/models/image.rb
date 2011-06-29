# == Schema Information
# Schema version: 20110615133925
#
# Table name: images
#
#  id                 :integer(4)      not null, primary key
#  uploadable_id      :integer(4)
#  uploadable_type    :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  upload_type        :string(255)
#

class Image < ActiveRecord::Base
  belongs_to :uploadable, :polymorphic => true
  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h,:need_cropping
  
  def cropping?  
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?  
  end 
   
  def photo_geometry(style = :original)  
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(photo.to_file(style)) # TODO: does not work with s3
  end
  
  def delete_photo=(value)
    @delete_photo = !value.to_i.zero?
  end
  
  def delete_photo
    !!@delete_photo
  end
  
  alias_method :delete_photo?, :delete_photo
  
  def needed_cropping?
    geo = Paperclip::Geometry.from_file(photo.to_file(:original))
    min_width  = 79
    min_height = 54
    original_ratio = geo.width.fdiv(geo.height)
    desired_ratio  = min_width.fdiv(min_height)
    original_ratio < desired_ratio || original_ratio > desired_ratio
  end
  
  def resize     
    geo = Paperclip::Geometry.from_file(photo.to_file(:original))
    min_width  = 79
    min_height = 54
    original_ratio = geo.width.fdiv(geo.height)
    desired_ratio = min_width.fdiv(min_height)
    if original_ratio < desired_ratio
      # Vertical Image
      final_width  = min_width
      final_height = final_width.fdiv(geo.width) * geo.height
      self.need_cropping=true
    elsif original_ratio > desired_ratio
      # Horizontal Image
      final_height = min_height
      final_width  = final_height.fdiv(geo.height) * geo.width
      self.need_cropping=true
    elsif original_ratio == desired_ratio
      final_height = min_height
      final_width  = final_height.fdiv(geo.height) * geo.width
      self.need_cropping=false
    end
    "#{final_width.round}x#{final_height.round}!"
  end
end
