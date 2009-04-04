class InstallController < ApplicationController
  skip_before_filter :ip_banned_redirect  
  skip_before_filter :active_user
  skip_before_filter :set_time_zone
  skip_before_filter :set_default_theme
  
  def install
    # Establish and test the new database connection
    connection = ActiveRecord::Base.establish_connection(params[:database])
    # needs to be called so connected? actually returns correct value
    ActiveRecord::Base.connection
    if !ActiveRecord::Base.connected?
      flash[:error] = t(:database_credentials)
      ActiveRecord::Base.establish_connection(YAML::load("#{RAILS_ROOT}/config/database.yml")["development"])
      render :action => "index"
    else
      File.open("#{RAILS_ROOT}/config/database.yml", "w+") do |f|
         f.write YAML::dump({ 'development' => params[:database] })
       end
       `rake db:schema:load`
       `rake ts:config`
       `rake ts:start`
       Theme.create(:name => "blue", :is_default => true)
    
       u = User.create!(:login => params[:user][:login], :password => params[:user][:password], :password_confirmation => params[:user][:password], :email => params[:user][:email], :user_level => UserLevel.find_by_name(t(:Administrator)))
       administrator_group = Group.create!(:name => "Administrators", :owner => u) 
       # Admin can do everything!
       permissions = {}
       Permission.column_names.grep(/can/).each do |permission|
         permissions.merge!(permission => true)
       end
       
       administrator_group.permissions.create!(permissions)
       
       anonymous_password = Digest::SHA1.hexdigest(rand(99999999).to_s)
       u = User.create(:login => "anonymous", :password => anonymous_password, :password_confirmation => anonymous_password, :email => "anonymous@rboard.com", :user_level => UserLevel.find_by_name(t(:Anonymous)))
        anonymous_group = Group.create!(:name => "Anonymous", :owner => u) 
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
                                     :can_see_category => true)
       
       f = Forum.create(:title => t(:Welcome_to_rBoard), :description => t(:example_forum_description))
       t = f.topics.build(:subject => t(:Welcome_to_rBoard), :user => u)
       t.posts.build(:text => t(:Welcome_to_rBoard_post), :user => u)
       t.save
      
      # So the database.yml gets reloaded 
      `touch #{RAILS_ROOT}/tmp/restart.txt`
      ["app/controllers/install_controller.rb", "app/views/install", "app/views/layouts/install.html.erb", "app/helpers/install_helper.rb", "public/stylesheets/install.css", "public/index.html"].each do |file| 
        FileUtils.rm_r(File.join(RAILS_ROOT, file))    
      end
      
      self.current_user = User.authenticate(params[:login], params[:password])
      
      flash[:notice] = t(:Welcome_to_rBoard)
      redirect_to forums_path
    end
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:error] = t(:User_not_created)
    render :action => "index"
  end
  # Override this just in case.
  def login_from_cookie
    
  end
end
