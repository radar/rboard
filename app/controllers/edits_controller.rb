class EditsController < ApplicationController
  before_filter :find_post
  before_filter :moderator_login_required
  before_filter :store_location, :only => :index
  
  def index
    @edits = current_user.moderator? ? @post.edits.visible : @post.edits
  end
  
  def show
    @edit = @post.edits.find(params[:id])
    not_found if current_user.moderator? && @edit.hidden?
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  private
  
  def find_post
    @post = Post.find(params[:post_id], :include => :edits, :joins => :topic) unless params[:post_id].nil?
  end
  
  def not_found
    flash[:notice] = "The edit you were looking for cannot be found."
    redirect_back_or_default forums_path
  end
  
end