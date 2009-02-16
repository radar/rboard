class Admin::IndexController < Admin::ApplicationController
  # Provides a "welcome mat" for the admin section.
  
  def index
    @sections = ["categories", "forums", "users", "ranks", "themes"]
end