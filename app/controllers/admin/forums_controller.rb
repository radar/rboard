class Admin::ForumsController < Admin::ApplicationController
  before_filter :store_location, :only => [:index, :show]
  
  def new
    @forum = Forum.new
    @forums = Forum.find(:all, :order => "title")
  end
  
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      flash[:notice] = "Forum has been created."
      redirect
    else
      flash[:notice] = "Forum has not been created."
      render :action => "new"
    end
  end
  
  def index
    @forums = Forum.find_all_without_parent
  end
  
  def edit
    @forum = Forum.find(params[:id])
    @forums = Forum.find(:all, :order => "title") - [@forum] - @forum.descendants
  end
  
  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      flash[:notice] = "Forum has been updated."
      redirect
    else
      flash[:notice] = "Forum has not been updated."
      render :action => "edit"
    end
  end
  
  def move_up
    Forum.find(params[:id]).move_higher
    flash[:notice] = "The #{@forum} forum has been moved higher."
    redirect
  end
  
  def move_down
    Forum.find(params[:id]).move_lower
    flash[:notice] = "The #{@forum} forum has been moved lower."
    redirect
  end
  
  def move_to_top
    Forum.find(params[:id]).move_to_top
    flash[:notice] = "The #{@forum} forum has been moved to the top."
    redirect
  end
  
  def move_to_bottom
    Forum.find(params[:id]).move_to_bottom
    flash[:notice] = "The #{@forum} forum has been moved to the bottom."
    redirect
  end
  
  private
  
  #got tired of typing this method out again and again
  def redirect
    redirect_back_or_default(admin_forums_path)
  end
end