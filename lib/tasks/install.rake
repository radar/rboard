task :install => ['db:create:all', :environment] do
  Rake::Task["db:schema:load"].invoke
  
  # Themes
  Theme.create(:name => "blue", :is_default => true)
  
  # Users
  anonymous_password = rand(9999) * rand(9999)
  
  u = User.create!(:login => "anonymous", :password => anonymous_password, :password_confirmation => anonymous_password, :email => "anonymous@rboard.com")
  u.permissions.create!(:can_see_forum => true,
                        :can_see_category => true)
  
  u = User.create!(:login => "admin", :password => "secret", :password_confirmation => "secret", :email => "admin@rboard.com")
  
  # Admin can do everything!
  permissions = {}
  Permission.column_names.grep(/can/).each do |permission|
    permissions.merge(permission => true)
  end
  u.permissions.create!(permissions)
  
  # Groups 
  
  g = Group.create!(:name => "Registered Users", :owner => u)  
  
  # Forums
  c = Category.create!(:name => "Welcome")
  f = c.forums.create!(:title => "Welcome to rBoard!", :description => "This is just an example forum.")
  t = f.topics.build(:subject => "Welcome to rBoard!", :user => u)
  t.posts.build(:text => "Welcome to rBoard, feel free to remove this post, topic and forum.", :user => u)
  t.save!
  puts ""
  puts "***********************"
  puts "Rboard is now installed. The username is admin, and the password is secret."
end