class EditsController < ApplicationController
  before_filter :find_post
  before_filter :store_location, :only => :index
  before_filter :set_scope

  # @edits is defined inside #set_scope
  def index
  end

  # Will show an edit depending on whether or not the user can see it.
  def show
    @edit = @edits.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    edit_not_found
  end

  private

  def find_post
    @post = Post.find(params[:post_id], :include => :edits) unless params[:post_id].nil?
    if @post.nil?
      post_not_found
    else
      if !current_user.can?(:see_forum, @post.forum)
        flash[:notice] = t(:forum_object_permission_denied, :object => "post")
        redirect_back_or_default(root_path)
      end
    end
  rescue ActiveRecord::RecordNotFound
    post_not_found
  end

  def post_not_found
    flash[:notice] = t(:not_found, :thing => "post")
    redirect_back_or_default root_path
  end

  def edit_not_found
    flash[:notice] = t(:not_found, :thing => "edit")
    redirect_back_or_default root_path
  end

  def set_scope
    @edits = if current_user.can?(:manage_edits)
      @post.edits
    else
      @post.edits.visible
    end
  end
end