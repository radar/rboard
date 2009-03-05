task :install => ['db:create:all', :environment] do
  Rake::Task["db:schema:load"].invoke
  Theme.create(:name => "blue", :is_default => true)
  # Because position is the primary key, you cannot set it normally
  UserLevel.connection.execute("INSERT INTO user_levels (name, position) VALUES ('Anonymous', '1')")
  UserLevel.connection.execute("INSERT INTO user_levels (name, position) VALUES ('User', '2')")
  UserLevel.connection.execute("INSERT INTO user_levels (name, position) VALUES ('Moderator', '3')")
  UserLevel.connection.execute("INSERT INTO user_levels (name, position) VALUES ('Administrator', '4')")
  u = User.create(:login => "admin", :password => "secret", :password_confirmation => "secret", :email => "admin@rboard.com", :user_level => UserLevel.find_by_name("Administrator"))
  
  anonymous_password = Digest::SHA1.hexdigest(rand(99999999).to_s)
  u = User.create(:login => "anonymous", :password => anonymous_password, :password_confirmation => anonymous_password, :email => "anonymous@rboard.com", :user_level => UserLevel.find_by_name("Anonymous"))
  
  f = Forum.create(:title => "Welcome to rBoard!", :description => "This is just an example forum.", :is_visible_to => UserLevel.find_by_name("Administrator"), :topics_created_by => UserLevel.find_by_name("Administrator"))
  t = f.topics.build(:subject => "Welcome to rBoard!", :user => u)
  t.posts.build(:text => "Welcome to rBoard, feel free to remove this post, topic and forum.", :user => u)
  t.save
  puts ""
  puts "***********************"
  puts "Rboard is now installed. The username is admin, and the password is secret."
end