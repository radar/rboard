def highline
  @highline ||= begin
    require "highline"
    HighLine.new
  end
end
task :install => :environment do
  puts "Creating databases..."
  Rake::Task["db:create:all"].invoke if STANDALONE
  puts "Loading schema..."
  Rake::Task["db:schema:load"].invoke
  puts "*" * 50
  puts "Welcome to rBoard's install process."
  puts "*" * 50
  login = highline.ask("What would you like your login for the administrator account to be?")
  
  password = highline.ask("What would you like your password for this account to be?")
  
  email = highline.ask("What is your email address for this account?")
  
  login, password, email = [login, password, email].map!(&:strip)
   
   puts "Creating admin user now..."
   administrator = User.create!(:login => login, :password => password, :password_confirmation => password, :email => email)
  
   Theme.create(:name => "blue", :is_default => true)
   
   # Administrator account
  
   administrator_group = Group.create!(:name => "Administrators", :owner => administrator) 
   # Admin can do everything!
   permissions = {}
   Permission.column_names.grep(/can/).each do |permission|
     permissions.merge!(permission => true)
   end

   administrator_group.permissions.create!(permissions)
   
   puts "Creating anonymous user now..."
   anonymous_password = Digest::SHA1.hexdigest(rand(99999999).to_s)
   u = User.create(:login => "anonymous", :password => anonymous_password, :password_confirmation => anonymous_password, :email => "anonymous@rboard.com", :user_level => UserLevel.find_by_name(t(:Anonymous)))
    anonymous_group = Group.create!(:name => "Anonymous", :owner => u) 
    anonymous_group.permissions.create!(:can_see_forum => true,
                                        :can_see_category => true)
                                        
    

   puts "Creating registered users group..."
registered_group = Group.create!(:name => "Registered Users", :owner => administrator) 
                                         registered_group.permissions.create!(
                                         :can_see_forum => true,
                                         :can_see_category => true,
                                         :can_start_new_topics => true,
                                         :can_use_signature => true,
                                         :can_delete_own_posts => true,
                                         :can_edit_own_posts => true,
                                         :can_subscribe => true,
                                         :can_read_private_messages => true,
                                         :can_see_category => true)
                                        
   puts "Generating some configuration options..."
   Configuration.create(:key => "default_group_id", :value => registered_group.id)
   
   if THINKING_SPHINX
     puts "Configuring thinking sphinx..."
     Rake::Task['ts:config']
     puts "Running the index..."
     Rake::Task['ts:index']
     puts "Starting thinking sphinx up!"
     Rake::Task['ts:start']
   end
     
                                         
   puts "Creating first forum..."

   f = Forum.create(:title => t(:Welcome_to_rBoard), :description => t(:example_forum_description))
   
   puts "Creating first topic..."
   t = f.topics.build(:subject => t(:Welcome_to_rBoard), :user => u)
   puts "... and first topic..."
   t.posts.build(:text => t(:Welcome_to_rBoard_post), :user => u)
   t.save
   puts "Done!"
   
end