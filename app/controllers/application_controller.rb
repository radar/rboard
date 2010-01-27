class ApplicationController < ActionController::Base
  #Never, ever show password in the logs. Ever!
  filter_parameter_logging "password"

  include AuthenticatedSystem
  include Rboard::Auth

  # Login in the user from a cookie session store.
  before_filter :login_from_cookie

  # Redirect to the banned page if the requesting IP is banned.
  before_filter :ip_banned_redirect

  # Mark the current user as active if they're logged in.
  before_filter :active_user

  # Sets the page value to be a proper one if something nonsense is specified.
  before_filter :check_page_value

  # Sets the timezone to be the timezone that the user's specified.
  before_filter :set_time_zone

  # Sets the default theme

  before_filter :set_default_theme

  def set_default_theme
    @default_theme = Theme.find_by_is_default(true)
  end

  def check_page_value
    params[:page] = params[:page].to_i <= 0 ? "1" : params[:page]
  end

  def set_time_zone
    Time.zone = current_user.time_zone if logged_in? && !current_user.time_zone.nil?
  end
end