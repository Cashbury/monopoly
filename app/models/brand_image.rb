class BrandImage < Image
  belongs_to :brand
  has_attached_file :photo,
                    :styles => {
                      :thumb  => "100x100>",
                      :small  => "400x400>" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "brands/:id/:style/:filename"
                    
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE }

  # def photo
  #   self.uploadable.tmp_image ? self.brand.tmp_image.photo : self.photo
  # end
end
