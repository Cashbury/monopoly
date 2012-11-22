#image.rb allowed content type
IMAGES_CONTENT_TYPE = ['image/jpeg', 'image/jpg', 'image/pjpeg', 'image/png', 'image/bmp', 'image/bmpimage/x-bmp', 'image/gif']
IMAGES_CONTENT_TYPE_NAME = ['JPG', 'PNG', 'BMP','JPEG', 'GIF']
DISTANCE = 10
ENABLE_DELAYED_UPLOADS = false
STARTING_TIMER_SEC = 180
APP_CONFIG = YAML.load_file("#{Rails.root}/config/application.yml") [Rails.env]
COUNTRIES_FLAGS_PATH = "/images/countries/"

