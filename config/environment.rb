# Be sure to restart your web server when you modify this file.
# Uncomment this to force production mode.
# ENV['RAILS_ENV'] ||= 'production'

RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  config.gem 'chronic'
  config.gem 'ultraviolet', :lib => "uv"
   
  config.frameworks -= [:action_web_service, :action_mailer]
  config.action_controller.session = { :session_key => "rboard_secret", :secret => "this is a super secret passphrase that protects rboard" }

  config.active_record.default_timezone = :utc
  
end
# Application specific variables
DEFAULT_STYLESHEET = 1
PER_PAGE = 30
TIME_DISPLAY = "%I:%M:%S%p"
DATE_DISPLAY = "%d %B %Y" 
# Change this if your locale is not english
# I18n.default_locale = "en"
require 'array_ext'
RAILS_RELATIVE_URL_ROOT = "http://localhost"
#for some reason it doesn't automatically detect the admin's application controller.
Admin::ApplicationController