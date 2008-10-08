task :install => :environment do
  Rake::Task["db:schema:load"].invoke
  Theme.create(:name => "blue", :is_default => true)
  UserLevel.create(:name => "User", :position => 1)
  UserLevel.create(:name => "Moderator", :position => 2)
  UserLevel.create(:name => "Administrator", :position => 3)
  User.create(:login => "admin", :password => "secret", :password_confirmation => "secret", :email => "admin@rboard.com", :user_level => UserLevel.find_by_name("Administrator"))
  puts "Rboard is now installed. The username is admin, and the password is secret."
end