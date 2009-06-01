# I tried using Machinist.
# It didn't work out so well.
# It claimed named blueprints didn't exist... when they did!

class User < ActiveRecord::Base
  def self.make(name)
    opts = case name.to_s
      when 'anonymous'
        group = Group.find_by_name("anonymous") || Group.make(:anonymous)
        { :login => "anonymous",
          :password => "password",
          :password_confirmation => "password",
          :email => "anony@mous.com",
          :groups => [group] }
      when 'administrator'
        { :login => "administrator", 
          :password => "password",
          :password_confirmation => "password",
          :email => "admin@rboard.com"
         }
      when 'registered_user'
        group = Group.find_by_name("Registered Users") || Group.make(:registered_users)
        { :login => "registered_user", 
          :password => "password",
          :password_confirmation => "password",
          :email => "registered@user.com",
          :groups => [group]
        }
    end
    puts "creating user with #{opts.inspect}"
    User.create!(opts)
  end
end

class Group < ActiveRecord::Base
  def self.make(name)
    opts = case name.to_s
      when 'administrators'
        { :name => "Administrators" }
      when 'anonymous'
        { :name => "Anonymous",
          :owner => User.find_by_login("Administrator") || User.make(:administrator) }
      when 'registered_users'
        { :name => "Registered Users",
          :owner => User.find_by_login("Administrator") || User.make(:administrator) }
    end
    Group.create!(opts)
  end
end

class Permission < ActiveRecord::Base
  def self.make(name)
    opts = case name.to_s
      when 'anonymous'
        { :can_see_forum => true,
          :group => Group.find_by_name("Anonymous") || Group.make(:anonymous)
        }
      when 'registered_users'
        { :can_see_forum => true,
          :can_reply_to_topics => true, 
          :can_start_new_topics => true,
          :group => Group.find_by_name("Registered Users") || Group.make(:registered_users)
        }
    end
    Permission.create!(opts)
  end
end

class Forum < ActiveRecord::Base
  def self.make(name)
    opts = case name.to_s
      when 'public_forum'
        { :title => "Public Forum", 
          :description => "For all to see" }
    end
  Forum.create!(opts)
  end
end
  
        
        
        
        
        
        