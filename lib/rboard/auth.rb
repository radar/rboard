module Rboard::Auth
  # Store the given user in the session.
   def current_user=(new_user)
     return if new_user.nil?
     new_user.previous_login = current_user.login_time
     new_user.login_time = Time.now
     new_user.ip = request.remote_addr
     ip = Ip.find_or_create_by_ip(request.remote_addr)
     ip.users << new_user
     new_user.save
     session[:user] = new_user.id
     @current_user = new_user
   end
  #Per Page value for paginated sections of the forums,
  def per_page
    logged_in? ? current_user.per_page : PER_PAGE
  end

  #how the user has selected they want to display the time
  def time_display
    logged_in? ? current_user.time_display : TIME_DISPLAY
  end

  #how the user has selected they want to display the date  
  def date_display
    logged_in? ? current_user.date_display : DATE_DISPLAY
  end

  def date_time_display
    date_display + " " + time_display
  end
  
  def non_admin_redirect
    if !current_user.can?(:access_admin_section)
      flash[:notice] = t(:need_to_be_admin)
      redirect_back_or_default(root_path)
    end
  end

  def non_moderator_redirect
    if !current_user.can?(:access_admin_section)
      flash[:notice] = t(:need_to_be_moderator)
      redirect_back_or_default(root_path)
    end
  end

  def ip_banned?
    @ips = BannedIp.find(:all, :conditions => ["ban_time > ?",Time.now]).select do |ip|
      !Regexp.new(ip.ip).match(request.remote_addr).nil? unless ip.nil?
    end
    flash[:ip] = @ips.first unless @ips.empty?
  end

  def ip_banned_redirect
    redirect_to :controller => ip_is_banned_users_path unless params[:action] == "ip_is_banned"  if ip_banned?
  end

  def user_banned?
    logged_in? ? current_user.banned? : false
  end

  def theme
    ThemesLoader.new
    theme = logged_in? && !current_user.theme.nil? ? current_user.theme : Theme.find_by_is_default(true)
    theme.nil? ? Theme.first : theme
  end

  def active_user
    current_user.update_attribute("login_time",Time.now) if logged_in?
  end

  # Modified for rBoard
  # Returns true or false, depending on if the user is an anonymous user or not.
  def logged_in?
    current_user != User.find_by_login("anonymous")
  end

  # Accesses the current user from the session.
  # Will also return the anonymous user if the user is not logged in.
  def current_user
    @current_user ||= (session[:user] && User.find_by_id(session[:user])) || User.find_by_login("anonymous")
  end
  
  # Use as a before filter to ensure that the user is logged in.
  def login_required
    # Gather data from HTTP-based authentication.
    username, password = get_auth_data
    
    self.current_user ||= User.authenticate(username, password) || User.find_by_login("anonymous") if username && password
    if !logged_in?
      flash[:notice] = t(:you_must_be_logged_in)
      redirect_to login_path
    end
  end
  
  def self.included(base)
    base.send :helper_method,
              :is_moderator?,
              :ip_banned?,
              :logged_in?,
              :user_banned?,
              :theme,
              :time_display,
              :date_display,
              :date_time_display,
              :per_page
  end
  
  private
   @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
   # gets BASIC auth info
   def get_auth_data
     auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
     auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
     return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
   end
 end