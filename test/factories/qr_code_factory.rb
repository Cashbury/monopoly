Factory.define :qr_code do |qrcode|
  qrcode.hash_code ActiveSupport::SecureRandom.hex(10) 
  qrcode.code_type 0
  qrcode.status    true
  qrcode.associatable_id  {Factory(:engagement).id}
  qrcode.associatable_type "Engagement"
end