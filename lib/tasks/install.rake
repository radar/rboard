task :install => ['db:create:all', 'db:schema:load' , :environment] do
  
  # Themes
  Theme.create(:name => "blue", :is_default => true)
  
  # Users
  anonymous_password = rand(9999) * rand(9999)
  
  a = User.create!(:login => "anonymous", :password => anonymous_password, :password_confirmation => anonymous_password, :email => "anonymous@rboard.com")
  
  u = User.create!(:login => "admin", :password => "secret", :password_confirmation => "secret", :email => "admin@rboard.com")

  
  # Groups 
  
  anonymous_group = Group.create!(:name => "Anonymous", :owner => a)
  anonymous_group.permissions.create!(:can_see_forum => true,
                        :can_see_category => true)
  registered_group = Group.create!(:name => "Registered Users", :owner => u) 
  registered_group.permissions.create!(:can_see_forum => true,
                        :can_see_category => true,
                        :can_start_new_topics => true,
                        :can_use_signature => true,
                        :can_delete_own_posts => true,
                        :can_edit_own_posts => true,
                        :can_subscribe => true,
                        :can_read_messages => true,
                        :can_see_category => true,
                        :can_see_category => true              
                        )
  administrator_group = Group.create!(:name => "Administrators", :owner => u) 
  # Admin can do everything!
  permissions = {}
  Permission.column_names.grep(/can/).each do |permission|
    permissions.merge(permission => true)
  end
  administrator_group.permissions.create!(permissions)
  
  # Forums
  c = Category.create!(:name => "Welcome")
  c.group_permissions += [GroupPermission.find_by_group_id(registered_group.id)]
  c.save
  
  f = c.forums.create!(:title => "Welcome to rBoard!", :description => "This is just an example forum.")
  f.group_permissions += [GroupPermission.find_by_group_id(registered_group.id)]
  f.save
  
  t = f.topics.build(:subject => "Welcome to rBoard!", :user => u)
  t.posts.build(:text => "Welcome to rBoard, feel free to remove this post, topic and forum.", :user => u)
  t.save!
  puts ""
  puts "***********************"
  puts "Rboard is now installed. The username is admin, and the password is secret."
end