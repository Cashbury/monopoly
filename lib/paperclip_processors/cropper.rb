module Paperclip  
  class Cropper < Thumbnail  
    def transformation_command  
      if crop_command && !skip_crop?
        (super.join(' ').sub(/ -crop \S+/, '') + crop_command).split(' ')
      else  
        super  
      end  
    end     
    def crop_command  
      target = @attachment.instance
      if target.cropping?
        " -crop #{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y}"  
      end  
    end  
    def skip_crop?
      ["100x100>"].include?(@target_geometry.to_s)
    end
  end  
end  
