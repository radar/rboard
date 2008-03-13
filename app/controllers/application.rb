#should be an exact duplication of application_controller.rb. This is because the Admin::ApplicationController inheritance from
#ApplicationController complains that it can't find ApplicationController unless it's named application_controller.
#ruby script/console will complain that it can't find application.rb, so we need both!

class ApplicationController < ActionController::Base
  #Never, ever show password in the logs. Ever!
  filter_parameter_logging "password"
  session :session_key => '_forum_session_id'
  include AuthenticatedSystem
  require 'chronic'
  require 'custom_methods'
  before_filter :login_from_cookie
  before_filter :ip_banned_redirect
  before_filter :active_user
  @default_theme = Theme.find_by_is_default(true)
end
