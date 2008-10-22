class Admin::ForumsController < Admin::ApplicationController
  before_filter :store_location, :only => [:index, :show]
  before_filter :find_forum, :except => [:new, :create, :index]
  
  # Shows all top-level forums.
  def index
    @forums = Forum.find_all_without_parent
  end
  
  # Initializes a new forum.
  def new
    @forum = Forum.new
    @forums = Forum.find(:all, :order => "title")
    @user_levels = UserLevel.find(:all, :order => "id DESC")
  end
  
  # Creates a new forum.
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      flash[:notice] = "Forum has been created."
      redirect
    else
      flash[:notice] = "Forum has not been created."
      @forums = Forum.find(:all, :order => "title")
      render :action => "new"
    end
  end
  
  # Edits a forum.  
  def edit
    # We do this so we can't make a forum a sub of itself, or any of its descendants...
    # As this would cause circular references which just aren't cool.
    @forums = Forum.find(:all, :order => "title") - [@forum] - @forum.descendants
    @user_levels = UserLevel.find(:all, :order => "id DESC")
  end
  
  # Updates a forum.
  def update
    if @forum.update_attributes(params[:forum])
      flash[:notice] = "Forum has been updated."
      redirect
    else
      flash[:notice] = "Forum has not been updated."
      render :action => "edit"
    end
  end
  
  # Deletes a forum.
  def destroy
    @forum.destroy
    flash[:notice] = "#{@forum} has been deleted."
    redirect
  end
  
  # Moves a forum one space up using an acts_as_list provided method.
  def move_up
    @forum.move_higher
    flash[:notice] = "The #{@forum} forum has been moved higher."
    redirect
  end
  
  # Moves a forum one space down using an acts_as_list provided method.
  def move_down
    @forum.move_lower
    flash[:notice] = "The #{@forum} forum has been moved lower."
    redirect
  end
  
  # Moves a forum to the top using an acts_as_list provided method.
  def move_to_top
    @forum.move_to_top
    flash[:notice] = "The #{@forum} forum has been moved to the top."
    redirect
  end
  
  # Moves a forum to the bottom using an acts_as_list helper.
  def move_to_bottom
    @forum.move_to_bottom
    flash[:notice] = "The #{@forum} forum has been moved to the bottom."
    redirect
  end
  
  private
  
  # Calls redirect_back_or_default to the index action.
  # Got tired of writing it all out for the move_* actions
  def redirect
    redirect_back_or_default(admin_forums_path)
  end
  
  # Find a forum. Most of the actions in this controller need a forum object.
  def find_forum
    @forum = Forum.find(params[:id]) unless params[:id].nil?
    rescue ActiveRecord::RecordNotFound
      not_found
  end
  
  # Called when the forum could not be found.
  def not_found
    flash[:notice] = "The forum you were looking for could not be found."
    redirect
  end
end