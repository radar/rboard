class ForumsController < ApplicationController
  before_filter :is_visible?, :only => [:show]
  
  def index
    @forums = logged_in? ? Forum.find_all_without_parent.select { |forum| forum.is_visible_to <= current_user.user_level_id } : Forum.find_all_without_parent.select { |forum| forum.is_visible_to == 1 }
    @forums.sort_by(&:position)
    @lusers = User.find(:all, :conditions => ['login_time > ?',Time.now-15.minutes]).map { |u| u.login }.to_sentence
    @users = User.count
    @posts = Post.count
    @topics = Topic.count
    @ppt = @posts > 0 ? @posts / @topics : 0
  end
  
  def show
    @forum ||= Forum.find(params[:id])
    @topics = Topic.paginate :page => params[:page], :per_page => 30, :conditions => "forum_id = #{params[:id]}", :order => "sticky DESC, id DESC"
    @forums = @forum.children.sort_by(&:position)
  end
  
  private
  def is_visible?
    @forum = Forum.find(params[:id])
    unless (logged_in? && @forum.is_visible_to <= current_user.user_level_id) || @forum.is_visible_to == 1
      flash[:notice] = "You do not have the permissions to access that forum."
      redirect_to forums_path
    end
  end
  
end
