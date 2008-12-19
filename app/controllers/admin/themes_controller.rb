class Admin::ThemesController < Admin::ApplicationController
  
  def index
    ThemesLoader.new
    @themes = Theme.all(:order => "name ASC")
  end
  
end
