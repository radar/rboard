#should be an exact duplication of application_controller.rb. This is because the Admin::ApplicationController inheritance from
#ApplicationController complains that it can't find ApplicationController unless it's named application_controller.
#ruby script/console will complain that it can't find application.rb, so we need both!

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
  
  @default_theme = Theme.find_by_is_default(true) if Theme.table_exists?
  
  def check_page_value
    params[:page] = params[:page].to_i <= 0 ? "1" : params[:page]
  end
  
  def moderator_login_required
    if !is_moderator?
      flash[:notice] = "You do not have permission to do that."
      redirect_back_or_default(forums_path)
    end
  end
  
  def moderated_topics_count
  
  end
  
end
