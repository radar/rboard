# Be sure to restart your web server when you modify this file.
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
database = File.join(RAILS_ROOT, "config/database.yml")
if !File.exist?(database)
  puts "You don't have a config/database.yml. Let us create that for you..."
  FileUtils.cp("#{RAILS_ROOT}/config/database.yml.sample", "#{RAILS_ROOT}/config/database.yml")
end

if File.readlines(database).empty?
  raise "Your database.yml file is empty. Please add your database information."
end

# Application specific variables MUST be set before the initializer is ran.
# Standard settings for rboard.

# Display 25 items per page.
PER_PAGE = 25

# Hour:Minute:Second[AM|PM]
# Change this if you want to change the default formatting of time.
TIME_DISPLAY = "%I:%M:%S%p"

# Day Month Year
# Change this if you want to change the default formatting of years.
DATE_DISPLAY = "%d %B %Y"

# Change this to point at a different themes directory. In jruby-rack Rails.public_path is not yet set.
THEMES_DIRECTORY = Proc.new { File.join(Rails.public_path, "themes") }


# Set this to false if you're integrating rboard into another app.
# This determines if rake db:create:all is ran when running the install script.
STANDALONE = true

## Set this to false if you don't want to use thinking sphinx.
SEARCHING = true


CONFIG = Rails::Initializer.run do |config|

  config.gem 'chronic'
  config.gem 'RedCloth'
  config.gem 'highline'
  config.gem 'coderay'

  # lol actionwebservice
  # lol activeresource
  config.frameworks -= [:action_web_service, :activeresource]

  config.action_controller.session = { :session_key => "rboard_secret", :secret => "this is a super secret passphrase that protects rboard and you should probably change it" }

  config.active_record.default_timezone = :utc
  config.time_zone = "UTC"

end

# Change this if your locale is not english
# I18n.default_locale = "en"
require 'class_ext'
require 'array_ext'
require 'themes_loader'
Dir.glob("#{RAILS_ROOT}/lib/rboard/*") { |f| require f }

require 'find'
themes = []
Find.find(RAILS_ROOT + "/public/themes") do |path|
  themes << [path, path] if File.directory?(path)
  Find.prune
end

Sass::Plugin.options[:template_location] = themes
