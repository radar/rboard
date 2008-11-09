class Moderator::EditsController < Moderator::ApplicationController
  before_filter :find_post
  before_filter :store_location, :only => :index
  
  def index
    @edits = current_user.moderator? ? @post.edits.visible : @post.edits
  end
  
  def show
    @edit = if current_user.moderator? 
      @post.edits.visible.find(params[:id])
    else
      @post.edits.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  private
  
  def find_post
    @post = Post.find(params[:post_id], :include => :edits, :joins => :topic) unless params[:post_id].nil?
    not_found if @post.nil?
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  def not_found
    flash[:notice] = t(:post_or_edit_not_found)
    redirect_back_or_default moderator_root_path
  end
  
end