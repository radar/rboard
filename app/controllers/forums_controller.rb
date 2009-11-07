class ForumsController < ApplicationController
  before_filter :store_location, :only => [:index, :show]
  before_filter :find_category
  before_filter :find_forum, :only => [:show]

  # Shows all root forums.
  # Limits this selection to forums the current user has access to.
  # Also gathers stats for the Compulsory Stat Box.
  def index
    if @category
      @forums = @category.forums.without_parent
      @forums = @forums.active if !current_user.can?(:see_inactive_forums)

    else
      # TODO: I encourage allcomers to find a better way.
      # FIXME: I have worked too long on this.
      # HELP: I need fresh eyes.
      @categories = Category.without_parent.select { |c| current_user.can?(:see_category, c) }
      @forums = Forum.without_category.without_parent.select { |f| current_user.can?(:see_forum, f) }
    end
    @lusers = User.recent.map { |u| u.to_s }.to_sentence
    # Remove one for anonymous
    @users = User.count - 1
    @posts = Post.count
    @topics = Topic.count
    @ppt = @posts > 0 ? @posts / @topics : 0
    respond_to do |format|
      format.html
      format.xml { render :xml => @forums }
    end
  end

  # Shows a forum.
  # Checks first if the current user can see it.
  def show
    p current_user.permissions.last.can_see_forum?
    @topics = @forum.topics.sorted.paginate :page => params[:page], :per_page => per_page, :include => :posts
    @forums = @forum.children
    @all_forums = Forum.all(:select => "id, title", :order => "title ASC") - [@forum] if current_user.can?(:move_topics, @forum)
    @moderated_topics_count = @forum.moderations.topics.for_user(current_user).count
  end

  private
    def find_forum
      @forums = current_user.can?(:see_inactive_forums) ? Forum : Forum.active
      @forum = @forums.find(params[:id], :include => [{ :topics => :posts }, :moderations, :permissions])
      if !current_user.can?(:see_forum, @forum)
        flash[:notice] = t(:forum_permission_denied)
        redirect_to forums_path
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = t(:forum_not_found_or_inactive)
      redirect_to forums_path
    end

    def find_category
      unless params[:category_id].blank?
        @category = Category.find(params[:category_id], :include => [:forums, :permissions])
        if !current_user.can?(:see_category, @category)
          flash[:notice] = t(:category_permission_denied)
          redirect_to root_path
        end
      end
    end

end
