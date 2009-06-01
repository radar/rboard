# Be sure to restart your web server when you modify this file.
# Uncomment this to force production mode.
ENV['RAILS_ENV'] = 'development'

RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
database = File.join(RAILS_ROOT, "config/database.yml")
if !File.exist?(database)
  raise "You must create a database.yml file."
end

if File.readlines(database).empty?
  raise "Your database.yml file is empty. Please add your database information."
end
CONFIG = Rails::Initializer.run do |config|
  
  config.gem 'chronic'
  config.gem 'RedCloth'
  config.gem 'highline'
  
  # lol actionwebservice
  config.frameworks -= [:action_web_service]
  
  config.action_controller.session = { :session_key => "rboard_secret", :secret => "this is a super secret passphrase that protects rboard" }
  
  config.active_record.default_timezone = :utc
  config.time_zone = "UTC"
  
end
# Application specific variables
# Standard settings for rboard.
# Display 25 items per page.
PER_PAGE = 25

# Hour:Minute:Second[AM|PM]
# Change this if you want to change the default formatting of time.
TIME_DISPLAY = "%I:%M:%S%p"

# Day Month Year
# Change this if you want to change the default formatting of years.
DATE_DISPLAY = "%d %B %Y"

# Change this to point at a different themes directory.
THEMES_DIRECTORY = File.join(RAILS_ROOT, "public", "themes")

# Set this to false if you're integrating rboard into another app.
# This determines if rake db:create:all is ran when running the install script.
STANDALONE = true

## Set this to false if you don't want to use thinking sphinx.
SEARCHING = true

# Change this if your locale is not english
# I18n.default_locale = "en"
require 'class_ext'
require 'array_ext'
require 'themes_loader'
Dir.glob("#{RAILS_ROOT}/lib/rboard/*") { |f| require f }
