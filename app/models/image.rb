class Image < ActiveRecord::Base
  belongs_to :uploadable, :polymorphic => true
  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
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
  
  def resize     
    geo = Paperclip::Geometry.from_file(photo.to_file(:original))
    ratio = geo.width/geo.height  
    min_width  = 79
    min_height = 54
    if ratio > 1
      # Horizontal Image
      final_height = min_height
      final_width  = final_height * ratio
      "#{final_width.round}x#{final_height.round}!"
    else
      # Vertical Image
      final_width  = min_width
      final_height = final_width * ratio
      "#{final_height.round}x#{final_width.round}!"
    end
  end
end
