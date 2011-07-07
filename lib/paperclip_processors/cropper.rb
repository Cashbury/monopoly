module Paperclip  
  class Cropper < Thumbnail  
    def transformation_command
      puts "ana gowa transformation"  
      if crop_command && !skip_crop?
        (super.join(' ').sub(/ -crop \S+/, '') + crop_command).split(' ')
      else  
        super  
      end  
    end     
    def crop_command  
      puts "ana gowa crop_command"
      target = @attachment.instance
      if target.cropping?
        puts "is cropping true"
        " -crop #{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y}"  
      else
       puts "need cropping is false"
      end  
    end  
    def skip_crop?
      ["100x100>","460x320>"].include?(@target_geometry.to_s)
    end
  end  
end  
