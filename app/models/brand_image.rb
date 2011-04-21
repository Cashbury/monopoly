class BrandImage < Image
  belongs_to :brand
  has_attached_file :photo,
                    :styles => {
                      :thumb  => "100x100>",
                      :small  => "400x400>" },
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "brands/:style/:id/:filename"
                    
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE }
end
