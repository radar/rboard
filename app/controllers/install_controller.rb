class InstallController < ApplicationController
  skip_before_filter :ip_banned_redirect  
  skip_before_filter :active_user
  skip_before_filter :set_time_zone
  skip_before_filter :set_default_theme

  def install
    # Establish and test the new database connection
    logger.debug params[:database].inspect
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
       
       # Because position is the primary key, you cannot set it normally
       UserLevel.connection.execute("INSERT INTO user_levels (name, position) VALUES ('#{I18n.t(:Anonymous)}', '1')")
       UserLevel.connection.execute("INSERT INTO user_levels (name, position) VALUES ('#{I18n.t(:User)}', '2')")
       UserLevel.connection.execute("INSERT INTO user_levels (name, position) VALUES ('#{I18n.t(:Moderator)}', '3')")
       UserLevel.connection.execute("INSERT INTO user_levels (name, position) VALUES ('#{I18n.t(:Administrator)}', '4')")
       
       u = User.create!(:login => params[:user][:login], :password => params[:user][:password], :password_confirmation => params[:user][:password], :email => params[:user][:email], :user_level => UserLevel.find_by_name(t(:Administrator)))
       
       anonymous_password = Digest::SHA1.hexdigest(rand(99999999).to_s)
       u = User.create(:login => "anonymous", :password => anonymous_password, :password_confirmation => anonymous_password, :email => "anonymous@rboard.com", :user_level => UserLevel.find_by_name(t(:Anonymous)))
       
       f = Forum.create(:title => t(:Welcome_to_rBoard), :description => t(:example_forum_description), :is_visible_to => UserLevel.find_by_name(t(:Administrator)), :topics_created_by => UserLevel.find_by_name(t(:Administrator)))
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
end
