class QrCodeImage < Image
  belongs_to :qr_code
  
  has_attached_file :photo, 
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "qrcodes/:id/:filename"
end
