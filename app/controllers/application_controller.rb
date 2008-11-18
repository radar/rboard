#should be an exact duplication of application_controller.rb. This is because
# the Admin::ApplicationController inheritance from ApplicationController 
# complains that it can't find ApplicationController unless it's named 
# application_controller. ruby script/console will complain that it can't find
# application.rb, so we need both!

class ApplicationController < ActionController::Base
  #Never, ever show password in the logs. Ever!
  filter_parameter_logging "password"

  include AuthenticatedSystem
  
  require 'chronic'
  require 'custom_methods'
  before_filter :login_from_cookie
  before_filter :ip_banned_redirect
  before_filter :active_user
  before_filter :check_page_value
  before_filter :set_time_zone
  
  @default_theme = Theme.find_by_is_default(true) if Theme.table_exists?
  
  def check_page_value
    params[:page] = params[:page].to_i <= 0 ? "1" : params[:page]
  end
  
  def set_time_zone
    Time.zone = current_user.time_zone if logged_in? && !current_user.time_zone.nil?
  end
end
