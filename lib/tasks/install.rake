task :install => :environment do
  Rake::Task["db:schema:load"].invoke
  Theme.create(:name => "blue", :is_default => true)
  User.create(:login => "admin", :password => "secret", :password_confirmation => "secret", :email => "admin@rboard.com")
  puts "Rboard is now installed. The username is admin, and the password is secret."
end