# Application specific variables MUST be set before the initializer is run.
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



# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RBoard::Application.initialize!




require 'class_ext'
require 'array_ext'
require 'themes_loader'
Dir.glob("#{Rails.root}/lib/rboard/*") { |f| require f }

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
