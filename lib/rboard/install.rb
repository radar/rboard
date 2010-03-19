module Rboard
  class << self
    def install!(login, password, email)
      begin
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
                                              :can_see_category => true,
                                              :can_reply_to_topics => true)

         puts "Generating some configuration options..."
         Configuration.create(:key => "subforums_display", :title => I18n.t(:subforums_display), :value => 3, :description => I18n.t(:subforums_display_description))

         if SEARCHING
           puts "Configuring thinking sphinx..."
           `rake ts:config RAILS_ENV=#{Rails.env}`
           puts "Running the index..."
           `rake ts:index  RAILS_ENV=#{Rails.env}`
           puts "Starting thinking sphinx up! This may take a while..."
           `rake ts:start  RAILS_ENV=#{Rails.env}`
         end


         puts "Creating first forum..."

         f = Forum.create(:title => I18n.t(:Welcome_to_rBoard), :description => I18n.t(:example_forum_description))

         puts "Creating first topic..."
         ip = Ip.create(:ip => "127.0.0.1")
         t = f.topics.build(:subject => I18n.t(:Your_first_topic), :user => u, :ip => ip)
         puts "... and first post..."
         t.posts.build(:text => I18n.t(:Welcome_to_rBoard_post), :user => u, :ip => ip)
         t.save
         puts "Done!"
         Theme.find_by_name("blue").update_attribute("is_default", true)
      rescue Exception => e
        p "Encountered an error (#{e.message}). Resetting the database in 5 seconds. Press CTRL+C if you don't want this to happen."
        sleep(5)
        `rake db:reset`
        p "Database reset! The error was:"
        raise e
      end  
    end
  end
end