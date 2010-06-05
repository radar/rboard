# Be sure to restart your web server when you modify this file.
require File.join(File.dirname(__FILE__), 'boot')
require 'fileutils'

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

CONFIG = Rails::Initializer.run do |config|

  config.gem 'by_star', :version => '0.6.3'
  config.gem 'chronic'
  config.gem 'coderay'
  config.gem 'i18n'
  config.gem 'dotiw'
  config.gem 'haml', :version => "2.2.21"
  config.gem 'highline'
  config.gem 'paperclip', :version => '2.3.1.1'
  config.gem 'RedCloth'
  config.gem 'thinking-sphinx', :lib => 'thinking_sphinx'
  config.gem 'will_paginate'


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

# Needs to be set for paperclip to find the identify command with Passenger.
begin
  require 'paperclip'
  Paperclip.options[:command_path] = "/usr/local/bin"
rescue LoadError
end

begin
  require 'sass'
  Sass::Plugin.options[:template_location] = themes
rescue LoadError
end

# def puts str
#   super caller.first if caller.first.index("shoulda.rb") == -1
#   super str
# end
# 
# def p obj
#   puts caller.first
#   super obj
# end
