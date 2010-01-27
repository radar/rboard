class Admin::ThemesController < Admin::ApplicationController

  def index
    ThemesLoader.new
    @themes = Theme.all(:order => "name ASC")
  end

  def make_default
    default_theme = Theme.find_by_is_default(true)
    default_theme.update_attribute(:is_default, false) if default_theme
    theme = Theme.find(params[:id])
    theme.update_attribute(:is_default, true)
    flash[:notice] = t(:theme_is_now_default, :theme => theme.name)
    redirect_back_or_default admin_themes_path
  end

end
