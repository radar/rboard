class Admin::ForumsController < Admin::ApplicationController
  before_filter :store_location, :only => [:index, :show]
  before_filter :find_forum, :except => [:new, :create, :index]
  before_filter :find_category

  # Shows all top-level forums.
  def index
    @forums = Forum.without_parent
  end

  # Initializes a new forum.
  def new
    @forum = if @category
      @category.forums.build
    else
      Forum.new
    end

    find_forums
  end

  # Creates a new forum.
  def create
    @forum = if @category
      @category.forums.build(params[:forum])
    else
      Forum.new(params[:forum])
    end
    if @forum.save
      flash[:notice] = t(:created, :thing => "Forum")
      redirect
    else
      flash[:notice] = t(:not_created, :thing => "forum")
      find_forums
      render :action => "new"
    end
  end

  # Edits a forum.  
  def edit
    # We do this so we can't make a forum a sub of itself, or any of its descendants...
    # As this would cause circular references which just aren't cool.
    find_forums
  end

  # Updates a forum.
  def update
    if @forum.update_attributes(params[:forum])
      flash[:notice] = t(:updated, :thing => "forum")
      redirect
    else
      flash[:notice] = t(:not_updated, :thing => "forum")
      find_forums
      render :action => "edit"
    end
  end

  # Deletes a forum.
  def destroy
    @forum.destroy
    flash[:notice] = t(:deleted, :thing => "forum")
    redirect
  end

  # Moves a forum one space up using an acts_as_list provided method.
  def move_up
    @forum.move_higher
    flash[:notice] = t(:moved_higher, :thing => "Forum")
    redirect
  end

  # Moves a forum one space down using an acts_as_list provided method.
  def move_down
    @forum.move_lower
    flash[:notice] = t(:moved_lower, :thing => "Forum")
    redirect
  end

  # Moves a forum to the top using an acts_as_list provided method.
  def move_to_top
    @forum.move_to_top
    flash[:notice] = t(:moved_to_top, :thing => "Forum")
    redirect
  end

  # Moves a forum to the bottom using an acts_as_list helper.
  def move_to_bottom
    @forum.move_to_bottom
    flash[:notice] = t(:moved_to_bottom, :thing => "Forum")
    redirect
  end

  private

  # Calls redirect_back_or_default to the index action.
  # Got tired of writing it all out for the move_* actions
  def redirect
    redirect_back_or_default(admin_forums_path)
  end

  def find_category
    @category = Category.find(params[:category_id]) if params[:category_id]
  end

  # Find a forum. Most of the actions in this controller need a forum object.
  def find_forum
    @forum = Forum.find(params[:id]) unless params[:id].nil?
    rescue ActiveRecord::RecordNotFound
      not_found
  end

  def find_forums
    @forums, @categories = if @category
      [@category.forums.find(:all, :order => "title ASC"), []]
    else
      [Forum.find(:all, :order => "title ASC"), Category.find(:all, :order => "name asc")]
    end
  end

  # Called when the forum could not be found.
  def not_found
    flash[:notice] = t(:not_found, :thing => "forum")
    redirect
  end

end