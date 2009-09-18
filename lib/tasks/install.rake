require 'lib/rboard/basic_setup'
def highline
  @highline ||= begin
    require "highline"
    HighLine.new
  end
end

# Ugh. As much as I hate ugly hacks, I have to do this.
# For what reason? It defaults to test. Always.
# I have absolutely no clue why.
# It is late on a Sunday night, all I want to do is relax and go to bed with a clear mind.
# If you can fix this better than I am, you are a better man (or woman)
# I have to do this.
# Forgive me.
def establish_connection  
  ActiveRecord::Base.establish_connection(YAML.load_file("#{RAILS_ROOT}/config/database.yml")[ENV['RAILS_ENV']])
end

task :install => :environment do
  ENV['RAILS_ENV'] = "production"
  puts "Creating databases..."
  # Check the comment for this method.
  establish_connection
  Rake::Task["db:create:all"].invoke if STANDALONE
  puts "Setting up the database"
  # Check the comment for this method.
  establish_connection
  Rake::Task["db:migrate"].invoke
  
  puts "*" * 50
  puts "Welcome to rBoard's install process."
  puts "*" * 50
  login = highline.ask("What would you like your login for the administrator account to be?")
  
  password = highline.ask("What would you like your password for this account to be?")
  
  email = highline.ask("What is your email address for this account?")
  
  login, password, email = [login, password, email].map!(&:strip)
   
   BasicSetup.new(login, password, email)
                                        
   puts "Generating some configuration options..."
   Configuration.create(:key => "subforums_display", :title => I18n.t(:subforums_display), :value => 3, :description => I18n.t(:subforums_display_description))
   
   if SEARCHING
     puts "Configuring thinking sphinx..."
     Rake::Task['ts:config']
     puts "Running the index..."
     Rake::Task['ts:index']
     puts "Starting thinking sphinx up!"
     Rake::Task['ts:start']
   end
     
                                         
   puts "Creating first forum..."

   f = Forum.create(:title => I18n.t(:Welcome_to_rBoard), :description => I18n.t(:example_forum_description))
   
   puts "Creating first topic..."
   t = f.topics.build(:subject => I18n.t(:Welcome_to_rBoard), :user => u)
   puts "... and first topic..."
   t.posts.build(:text => I18n.t(:Welcome_to_rBoard_post), :user => u)
   t.save
   puts "Done!"
   
end