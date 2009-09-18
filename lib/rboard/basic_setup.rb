class BasicSetup
  def initialize(login="admin", password="secret", email="admin@rboard.com")
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
  end
end