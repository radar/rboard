def highline
  @highline ||= begin
    require "highline"
    HighLine.new
  end
end

desc "Install rBoard database for the current RAILS_ENV"
task :install => :environment do
  ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
  if STANDALONE
    puts "Creating #{RAILS_ENV} database..."
    Rake::Task["db:create"].invoke
  end

  puts "Setting up the #{RAILS_ENV} database"
  Rake::Task["db:migrate"].invoke

  puts "*" * 50
  puts "Welcome to rBoard's install process."
  puts "*" * 50
  login = highline.ask("What would you like your login for the administrator account to be?")

  password = highline.ask("What would you like your password for this account to be?")

  email = highline.ask("What is your email address for this account?")
  Rboard.install!(login, password, email)
end