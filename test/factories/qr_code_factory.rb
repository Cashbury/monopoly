Factory.define :qr_code do |qrcode|
  qrcode.hash_code ActiveSupport::SecureRandom.hex(10) 
  qrcode.code_type 0
  qrcode.status    true
  qrcode.related_id  Factory.create(:engagement).id
  qrcode.related_type "Engagement"
end