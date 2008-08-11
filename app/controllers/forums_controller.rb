class ForumsController < ApplicationController
  before_filter :is_visible?, :only => :show
  
  def index
    @forums = Forum.find_all_without_parent.select { |forum| forum.viewable?(logged_in?, current_user) }
    @forums = @forums.sort_by { |f| f.position }
    @lusers = User.find(:all, :conditions => ['login_time > ?', Time.now-15.minutes]).map { |u| u.login }.to_sentence
    @users = User.count
    @posts = Post.count
    @topics = Topic.count
    @ppt = @posts > 0 ? @posts / @topics : 0
  end
  
  def show
    @topics = @forum.topics.paginate :page => params[:page], :per_page => 30, :order => "sticky DESC, id DESC", :include => [:posts => [:user]]
    @forums = @forum.children.sort_by { |f| f.position }
  end
  
  private
  def is_visible?
    @forum = Forum.find(params[:id])
    if !@forum.viewable?(logged_in?, current_user)
      flash[:notice] = "You do not have the permissions to access that forum."
      redirect_to forums_path
    end
  end
end
