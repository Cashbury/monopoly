#image.rb allowed content type
IMAGES_CONTENT_TYPE = ['image/jpeg', 'image/jpg', 'image/pjpeg', 'image/png', 'image/bmp', 'image/bmpimage/x-bmp']
IMAGES_CONTENT_TYPE_NAME = ['JPG', 'PNG', 'BMP','JPEG']
DISTANCE=10
ENABLE_DELAYED_UPLOADS=false
APP_CONFIG = YAML.load_file("#{Rails.root}/config/application.yml") [Rails.env]

