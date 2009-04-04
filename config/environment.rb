# Be sure to restart your web server when you modify this file.
# Uncomment this to force production mode.
ENV['RAILS_ENV'] = 'development'

RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
if File.readlines("config/database.yml").empty?
  raise "Your database.yml file is empty. Please add your database information."
end
Rails::Initializer.run do |config|
  
  config.gem 'chronic'
  config.gem 'RedCloth'
  config.frameworks -= [:action_web_service]
  config.action_controller.session = { :session_key => "rboard_secret", :secret => "this is a super secret passphrase that protects rboard" }
  config.active_record.default_timezone = :utc
  config.time_zone = "UTC"
  
end
# Application specific variables
PER_PAGE = 25
TIME_DISPLAY = "%I:%M:%S%p"
DATE_DISPLAY = "%d %B %Y"
THEMES_DIRECTORY = File.join(RAILS_ROOT, "public", "themes")
RAILS_RELATIVE_URL_ROOT = "http://localhost:3000"
# Change this if your locale is not english
# I18n.default_locale = "en"
require 'class_ext'
require 'array_ext'
require 'themes_loader'
Dir.glob("#{RAILS_ROOT}/lib/rboard/*") { |f| require f }
