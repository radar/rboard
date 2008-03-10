class Admin::ThemesController < Admin::ApplicationController
  
  def index
    #FIXME: possibly CPU intensive, and may need to be done else where.
    @themes = Dir.entries("#{RAILS_ROOT}/public/themes") - ['.svn','..','.']
    @themes.each { |theme| Theme.create(:name => theme) }
    @themes = Theme.find(:all)
    for theme in @themes
      if !File.exist?("#{RAILS_ROOT}/public/themes/#{theme.name}")
        @themes -= [theme]
        theme.destroy
      end
    end
  end
  
  #  def new
  #    @theme = Theme.new
  #  end
  #  
  #  def create
  #    @theme = Theme.new(params[:theme])
  #    if @theme.save
  #      flash[:notice] = "Theme has been created."
  #      redirect_to admin_themes_path
  #    else
  #      flash[:notice] = "Theme has not been created."
  #      render :action => "new"
  #    end
  #  end
  #  
  #  def edit
  #    @theme = Theme.find(params[:id])
  #  end
  #  
  #  def update
  #    @theme = Theme.find(params[:id])
  #    if @theme.update_attributes(params[:theme])
  #      flash[:notice] = "Theme has been updated."
  #      redirect_to admin_themes_path
  #    else
  #      flash[:notice] = "Theme has not been updated."
  #      render :action => "edit"
  #    end
  #  end
  #  
  #  def destroy
  #    @theme = Theme.find(params[:id])
  #    @theme.destroy
  #    flash[:notice] = "Theme has been deleted."
  #  rescue ActiveRecord::RecordNotFound
  #    flash[:notice] = "The theme you were looking for could not be found."
  #  ensure
  #    redirect_to admin_themes_path
  #  end
  
end
