source :gemcutter
source "http://gemcutter.org"
gem 'rack', "1.2.1"
gem 'rails', '3.0.3'
gem 'mysql2', '=0.2.11'

group :development do
  gem 'railroady'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-cucumber'
  gem 'guard-spork'
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-ext'
end

group :test do
  gem 'shoulda', '=2.11.3'
  gem 'mocha', '=0.9.12'
  gem 'rcov','=0.9.9'
  gem "factory_girl_rails", "~> 1.4.0"
end

group :test, :development do
  gem "rspec-rails", "~> 2.6"
  gem 'cucumber-rails', '~> 1.2.1'
  # must have QT installed; follow link below for instructions
  # https://github.com/thoughtbot/capybara-webkit/wiki/Installing-QT
  gem 'capybara-webkit', :git => "git://github.com/thoughtbot/capybara-webkit"
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'forgery'
  gem 'cucumber-api-steps', :require => false
end


gem 'devise', "~>1.1.5"
gem 'nifty-generators', '=0.4.5'
gem "transitions", :require => ["transitions", "active_record/transitions"]
gem "will_paginate", "~> 3.0.pre2"
gem 'jquery-rails','=0.2.7'
gem 'carmen','=0.2.5'
gem 'jquery-rails','=0.2.7'
gem 'carmen','=0.2.5'
gem 'wicked_pdf','=0.6.0'
gem 'geokit-rails3','=0.1.2'
gem 'calendar_date_select', :git => 'http://github.com/paneq/calendar_date_select.git', :branch =>'rails3test'
gem 'wkhtmltopdf','=0.1.2'
gem 'carrierwave','=0.5.2'
gem 'delayed_job','=2.1.4'
gem 'acts-as-taggable-on', '=2.0.6'
gem 'rmagick','=2.13.1' #server has this
gem 'aws-s3','=0.6.2'
gem 'paperclip','=2.3.11'
gem 'cancan' , "=1.6.5"
gem 'currencies',:require => 'iso4217'
gem "places" #for google places
gem 'make_flaggable'
gem "alphadecimal"
gem "rake",'=0.8.7'
