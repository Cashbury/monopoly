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
