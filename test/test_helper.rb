ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'shoulda/rails'
require 'factory_girl'
class ActiveSupport::TestCase
  #TODO  include Devise::TestHelpers should be included in the action controller test case only , not in test helper
	#include Devise::TestHelpers 
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end
