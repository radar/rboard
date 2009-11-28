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

  login, password, email = [login, password, email].map!(&:strip)
   puts "Creating admin user now..."
   administrator = User.new(:login => login, :password => password, :password_confirmation => password, :email => email)
   administrator.identifier = "administrator"
   administrator.save!

   Theme.create(:name => "blue", :is_default => true)

   # Administrator account

   administrator_group = Group.new(:name => "Administrators", :owner => administrator) 
   administrator_group.identifier = "administrators"
   administrator_group.save!

   # Admin can do everything!
   permissions = {}
   Permission.column_names.grep(/can/).each do |permission|
     permissions.merge!(permission => true)
   end

   administrator_group.permissions.create!(permissions)

   puts "Creating anonymous user now..."
   anonymous_password = Digest::SHA1.hexdigest(rand(99999999).to_s)
   u = User.new(:login => "anonymous", :password => anonymous_password, :password_confirmation => anonymous_password, :email => "anonymous@rboard.com", :user_level => UserLevel.find_by_name(I18n.t(:Anonymous)))
   u.identifier = "anonymous"
   u.save!

   anonymous_group = Group.new(:name => "Anonymous", :owner => u)
   anonymous_group.identifier = "anonymous"
   anonymous_group.save!

   anonymous_group.permissions.create!(:can_see_forum => true,
                                        :can_see_category => true)



   puts "Creating registered users group..."
   registered_group = Group.new(:name => "Registered Users", :owner => administrator) 
   registered_group.identifier = "registered_users"
   registered_group.save!

   registered_group.permissions.create!(:can_see_forum => true,
                                        :can_see_category => true,
                                        :can_start_new_topics => true,
                                        :can_use_signature => true,
                                        :can_delete_own_posts => true,
                                        :can_edit_own_posts => true,
                                        :can_subscribe => true,
                                        :can_read_private_messages => true,
                                        :can_see_category => true)

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